extends Node

signal player_joined(id: int)
signal player_left(id: int)
signal inputs_gathered(input_dict:Dictionary[int,InputData])

var input_dict: Dictionary[int,InputData]
var prev_input_dict: Dictionary[int,InputData]
var inputs :Array[StringName]
var dead_zone = 0.2
var most_recent_device_id:=-1

func _ready() -> void:
	inputs = InputMap.get_actions() as Array[StringName]
	inputs = inputs.filter(func(val:String):return not val.begins_with("ui"))
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	input_dict[-1]=InputData.new()
	prev_input_dict[-1]=InputData.new()

func _process(_delta: float) -> void:
	_collect_inputs()
	_send_inputs()
	_reset_inputs()

func _input(event: InputEvent) -> void:
	var id = event.device

	#If Keyboard or Mouse
	if id == 16 or id == 32: id = -1

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		input_dict[-1].direction_alt += Vector2(event.relative.x,event.relative.y)
		return

	var relevant_event_id = inputs.find_custom(func(val):return InputMap.event_is_action(event,val))
	var relevant_joypad_axis = event is InputEventJoypadMotion and event.axis_value > dead_zone

	var all_relevant_events = InputMap.action_get_events(inputs[relevant_event_id])

	if relevant_event_id != -1 or relevant_joypad_axis:
		most_recent_device_id = id
	if input_dict.has(id) and relevant_event_id != -1:
		if event.is_pressed():
			if not input_dict[id].held_actions.has(inputs[relevant_event_id]):
				input_dict[id].held_actions.append(inputs[relevant_event_id])
				input_dict[id].just_pressed_actions.append(inputs[relevant_event_id])
			else:
				input_dict[id].just_pressed_actions.erase(inputs[relevant_event_id])
		else:
			input_dict[id].held_actions.erase(inputs[relevant_event_id])

func _on_joy_connection_changed(id, connected):
	if connected:
		print("joy connected: ", id)
		input_dict[id] = InputData.new()
		prev_input_dict[id] = InputData.new()
		player_joined.emit(id)
	else:
		input_dict.erase(id)
		prev_input_dict.erase(id)
		player_left.emit(id)

func _collect_inputs() -> void:
	for id in input_dict.keys():
		for prev_held_input in prev_input_dict[id].held_actions:
			if not input_dict[id].held_actions.has(prev_held_input):
				input_dict[id].just_released_actions.append(prev_held_input)
		input_dict[id].direction = _get_direction(id,true)
		if not id == -1:
			input_dict[id].direction_alt = _get_direction(id,false)

func _send_inputs() -> void:
	inputs_gathered.emit(input_dict)

func _reset_inputs() -> void:
	for id in input_dict.keys():
		prev_input_dict[id].held_actions = input_dict[id].held_actions.duplicate()
		input_dict[id].direction = Vector2.ZERO
		input_dict[id].direction_alt = Vector2.ZERO
		input_dict[id].just_pressed_actions.clear()
		input_dict[id].just_released_actions.clear()

func _get_direction(id,main=true):
	var input_x:=0.0
	var input_y:=0.0
	if id == -1:
		input_x = float(input_dict[-1].held_actions.has("RIGHT"))-float(input_dict[-1].held_actions.has("LEFT"))
		input_y = float(input_dict[-1].held_actions.has("DOWN"))-float(input_dict[-1].held_actions.has("UP"))
	else:
		input_x = Input.get_joy_axis(id,JOY_AXIS_LEFT_X if main else JOY_AXIS_RIGHT_X)
		input_y = Input.get_joy_axis(id,JOY_AXIS_LEFT_Y if main else JOY_AXIS_RIGHT_Y)
	if absf(input_x) < dead_zone: input_x = 0.0
	if absf(input_y) < dead_zone: input_y = 0.0
	var input_vec2 = Vector2(input_x, input_y)
	return input_vec2
