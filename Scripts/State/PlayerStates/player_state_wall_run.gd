class_name PlayerStateWallRun
extends PlayerState

@export var arm_offset_vector:Vector3
@export var wall_run_cost:=1.0
@export var wall_scale_cost:=30.0
var arm:Arm

func enter(_data=null)->void:
	#_update_arms()
	super(_data)

func exit()->void:
	player.camera_rotation.set_camera_roll(0)
	if arm: arm.set_copy_amount(0)
	super()

func physics_tick(delta)->void:
	var sphere_cast_collision = player.wall_run.get_shape_cast_collisions() as Array
	if not sphere_cast_collision :
		transition.emit(STATE_STRINGS.INAIR)
		return
	var is_scaling = player.wall_run.look_dir_implies_scaling()
	_update_camera_roll()
	_update_arms()
	if is_scaling:
		player.velocity.x = Util.decay(player.velocity.x,5.0,delta)
		player.velocity.z = Util.decay(player.velocity.z,5.0,delta)
		player.head_bob.enabled = true
		var can_use = true
		for hand in Arms.Hand.values():
			if not player.stamina_meters[hand].try_use(wall_scale_cost*delta):
				can_use = false
		if not can_use:
			player.movement.air_jump(sphere_cast_collision[1])
			transition.emit(STATE_STRINGS.INAIR)
			return
		player.wall_run.scale(delta)
	else:
		if not arm:
			player.movement.air_jump(-sphere_cast_collision[1])
			transition.emit(STATE_STRINGS.INAIR)
			return
		player.head_bob.enabled = false
		var can_use = player.stamina_meters[arm.hand].try_use(wall_run_cost*delta)
		if not can_use:
			player.movement.air_jump(-sphere_cast_collision[1])
			transition.emit(STATE_STRINGS.INAIR)
			return
		player.wall_run.move(delta)
		#arm.set_target_position(sphere_cast_collision[0]+arm_offset_vector)
		#var relevant_hand = player.wall_run.get_relevant_hand()
		#if relevant_hand != -1:
			#player.arms.set_arm_target_position(relevant_hand,sphere_cast_collision[0]+arm_offset_vector)

func process_inputs(input_data:InputData)->void:
	if input_data.just_pressed_actions.has("JUMP"):
		var direction = input_data.direction
		direction = player.head.global_basis.x * Vector3(direction.x, 0, direction.y).normalized()
		player.movement.air_jump(direction)
	super(input_data)

func _check_transitions(input_data:InputData)->void:
	super(input_data)
	if player.is_on_floor():
		_handle_fall_kick()
		transition.emit(STATE_STRINGS.IDLE)
	if not input_data.held_actions.has("SPRINT"):
		transition.emit(STATE_STRINGS.INAIR)

func _update_arms():
	var relevant_hand = player.wall_run.get_relevant_hand()
	if relevant_hand!= null and relevant_hand!=-1:
		#var other_hand = (relevant_hand+1)%2
		arm = player.arms.arms_dict[relevant_hand]
		#var other_arm = player.arms.arms_dict[other_hand]
		#arm.set_copy_amount(1)
		#other_arm.set_copy_amount(0)
		#player.arms.set_arm_action(relevant_hand,Arm.Action.WALLRUNNING)
		#player.arms.set_arm_action(other_hand,Arm.Action.IDLE)
	else:
		arm = null
		#for hand in Arms.Hand.values():
			#player.arms.set_arm_action(hand,Arm.Action.IDLE)
			#player.arms.arms_dict[hand].set_copy_amount(0)

func _update_camera_roll():
	var dot = player.wall_run.get_dot_product_to_wall()
	player.camera_rotation.set_camera_roll(-dot)
