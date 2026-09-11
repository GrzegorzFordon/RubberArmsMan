class_name PlayerStateIdle
extends PlayerState

func enter(_data=null)->void:
	super(_data)

func exit()->void:
	super()

func tick(_delta)->void:
	_move_player(Movement.MOVE_TYPE.NONE)
	super(_delta)

func process_inputs(input_data:InputData)->void:
	super(input_data)

func _check_transitions(input_data:InputData)->void:
	if player.velocity.y < 0:
		transition.emit(STATE_STRINGS.INAIR)
	if player.grappling.active_grappling_targets.size():
		transition.emit(STATE_STRINGS.GRAPPLING)
	if input_data.just_pressed_actions.has("JUMP"):
		transition.emit(STATE_STRINGS.JUMP)
	if input_data.just_pressed_actions.has("CROUCH"):
		transition.emit(STATE_STRINGS.CROUCH)
	if input_data.direction.length()>0.0:
		transition.emit(STATE_STRINGS.RUN)
	super(input_data)
