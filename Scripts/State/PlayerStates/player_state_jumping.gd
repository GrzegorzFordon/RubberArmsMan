class_name PlayerStateJumping
extends PlayerState


func enter(_data=null)->void:
	var look_dir = -player.camera.global_basis.z
	var dot = look_dir.dot(Vector3.DOWN)
	var power_mult = 2.0 if dot > 0.9 else 1.0
	player.movement.jump(power_mult)
	super(_data)

func exit()->void:
	super()
	pass

func physics_tick(_delta)->void:
	super(_delta)
	var is_sprint = player.last_input_data.held_actions.has("SPRINT")
	var movement_type = Movement.MOVE_TYPE.SPRINT if is_sprint else Movement.MOVE_TYPE.RUN
	_move_player(movement_type)

func _check_transitions(input_data:InputData)->void:
	if player.grappling.active_grappling_targets.size():
		transition.emit(STATE_STRINGS.GRAPPLING)
	if input_data.just_pressed_actions.has("CROUCH"):
		transition.emit(STATE_STRINGS.AIRSLAM)
	if player.velocity.y < 0:
		transition.emit(STATE_STRINGS.INAIR)
	if player.is_on_floor():
		transition.emit(STATE_STRINGS.IDLE)
	super(input_data)
