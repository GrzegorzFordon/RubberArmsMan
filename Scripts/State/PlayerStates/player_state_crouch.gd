class_name PlayerStateCrouch
extends PlayerState

func enter(_data=null)->void:
	player.crouching.set_crouch(true)
	super(_data)

func exit()->void:
	player.crouching.set_crouch(false)
	super()

func tick(_delta)->void:
	super(_delta)

func process_inputs(input_data:InputData)->void:
	_move_player(Movement.MOVE_TYPE.CROUCH)
	super(input_data)

func _check_transitions(input_data:InputData)->void:
	if not input_data.held_actions.has("CROUCH"):
		transition.emit(STATE_STRINGS.IDLE)
	if input_data.just_pressed_actions.has("JUMP"):
		transition.emit("PlayerStateFly")
	super(input_data)
