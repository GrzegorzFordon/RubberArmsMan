class_name PlayerStateInAir
extends PlayerState

var additional_jumps_count:=0
@export var decay_amount:=10.0

var cached_enter_velocity
func enter(_data=null)->void:
	additional_jumps_count = 0
	cached_enter_velocity = player.velocity
	super(_data)
	pass

func exit()->void:
	super()

func tick(_delta)->void:
	#_handle_fall_kick(cached_vel_y)
	cached_enter_velocity -= cached_enter_velocity * decay_amount * _delta
	if cached_enter_velocity.length() <= 0.0:
		cached_enter_velocity = Vector3.ZERO
	var vel = cached_enter_velocity - player.head.global_basis.z * cached_enter_velocity.length() * 0.1
	player.velocity += vel * _delta
	player.velocity.y -= player.movement.fall_gravity*_delta
	player.move_and_slide()
	super(_delta)
	pass

func process_inputs(input_data:InputData)->void:
	if input_data.just_pressed_actions.has("JUMP"):
		if additional_jumps_count == 0:
			additional_jumps_count+=1
			var last_input_direction = player.last_input_data.direction
			var direction := player.head.global_basis * Vector3(last_input_direction.x, 0, last_input_direction.y).normalized()
			player.movement.air_jump(direction)
	super(input_data)

func _check_transitions(input_data:InputData)->void:
	if player.grappling.active_grappling_targets.size():
		transition.emit(STATE_STRINGS.GRAPPLING)
	if input_data.just_pressed_actions.has("CROUCH"):
		transition.emit(STATE_STRINGS.AIRSLAM)
	if input_data.held_actions.has("SPRINT"):
		if player.wall_run.get_shape_cast_collisions():
			#if player.stamina_meters.values().all(func(x):return x.cur_value > 20):
				transition.emit(STATE_STRINGS.WALLRUN)
	if player.is_on_floor():
		_handle_fall_kick()
		transition.emit(STATE_STRINGS.IDLE)
	super(input_data)
	pass
