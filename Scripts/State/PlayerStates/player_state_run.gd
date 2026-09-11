class_name PlayerStateRun
extends PlayerState

func enter(_data=null)->void:
	super(_data)
	pass

func exit()->void:
	super()
	pass

func tick(delta)->void:
	var movement_type = Movement.MOVE_TYPE.RUN
	var is_sprint = player.last_input_data.held_actions.has("SPRINT")
	if is_sprint:
		var can_sprint = true
		for hand in Arms.Hand.values():
			if not player.stamina_meters[hand].try_use(5.0*delta): can_sprint = false
			if can_sprint:
				movement_type = Movement.MOVE_TYPE.SPRINT
	_move_player(movement_type)
	super(delta)

func _check_transitions(input_data:InputData)->void:
	if player.grappling.active_grappling_targets.size():
		transition.emit(STATE_STRINGS.GRAPPLING)
	if player.velocity.y < 0:
		transition.emit(STATE_STRINGS.INAIR)
	if input_data.just_pressed_actions.has("JUMP"):
		transition.emit(STATE_STRINGS.JUMP)
	if input_data.just_pressed_actions.has("CROUCH"):
		transition.emit(STATE_STRINGS.CROUCH)
	if input_data.direction.length()==0.0:
		transition.emit(STATE_STRINGS.IDLE)
	super(input_data)
