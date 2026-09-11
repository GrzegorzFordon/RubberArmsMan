class_name PlayerStateFly
extends PlayerState

@export var fly_speed:=10.0
var fly_speed_mod:=1.0
func tick(_delta)->void:
	pass

func process_inputs(input_data:InputData)->void:
	#_move_player(Movement.MOVE_TYPE.NONE)
	if input_data.just_pressed_actions.has("SCROLL_UP"):
		fly_speed_mod += 0.5
	if input_data.just_pressed_actions.has("SCROLL_DOWN"):
		fly_speed_mod -= 0.5
	fly_speed_mod = clamp(fly_speed_mod,1.0,10.0)
	var pos_vector = Vector3.ZERO
	pos_vector += player.global_basis.x * input_data.direction.x
	pos_vector += player.head.global_basis.z * input_data.direction.y
	if Input.is_key_pressed(KEY_Q): pos_vector -= player.global_basis.y
	if Input.is_key_pressed(KEY_E): pos_vector += player.global_basis.y
	var is_sprint = Input.is_key_pressed(KEY_SHIFT)
	player.global_position += pos_vector * fly_speed * fly_speed_mod * (2 if is_sprint else 1) * get_process_delta_time()
	
	super(input_data)
	if input_data.just_pressed_actions.has("CROUCH"):
		transition.emit(STATE_STRINGS.IDLE)
