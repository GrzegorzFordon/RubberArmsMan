class_name PlayerStateGrappling
extends PlayerState

@export var stamina_use_per_second:=25

var stamina_use_mult:=1.0

func enter(_data=null)->void:
	for hand in player.grappling.active_grappling_targets.keys():
		player.arms.set_arm_action(hand,Arm.Action.GRAPPLING)
	super(_data)

func exit()->void:
	for hand in player.grappling.active_grappling_targets:
		player.grappling.retreat(hand)
	super()

func tick(_delta)->void:
	player.head_bob.enabled = player.is_on_floor()
	for hand in player.grappling.active_grappling_targets.keys():
		var target_pos = player.grappling.active_grappling_targets[hand].get_world_pos_with_offset()
		var arm = player.arms.arms_dict[hand] as Arm
		player.arms.set_arm_target_position(hand,target_pos)
	super(_delta)

func process_inputs(input_data:InputData)->void:
	if input_data.just_pressed_actions.has("INTERACT"):
		player.grappling.launch(Arms.Hand.LEFT)
		player.arms.set_arm_action(Arms.Hand.LEFT,Arm.Action.GRAPPLING)
	if input_data.just_pressed_actions.has("ALT_ACTION"):
		player.grappling.launch(Arms.Hand.RIGHT)
		player.arms.set_arm_action(Arms.Hand.RIGHT,Arm.Action.GRAPPLING)
	if input_data.just_released_actions.has("INTERACT"):
		player.grappling.retreat(Arms.Hand.LEFT)
		player.arms.set_arm_action(Arms.Hand.LEFT,Arm.Action.IDLE)
	if input_data.just_released_actions.has("ALT_ACTION"):
		player.grappling.retreat(Arms.Hand.RIGHT)
		player.arms.set_arm_action(Arms.Hand.RIGHT,Arm.Action.IDLE)
	if input_data.held_actions.has("SPRINT"):
		player.grappling.shorten(get_process_delta_time())
		stamina_use_mult = 2.0
	else:
		stamina_use_mult = 1.0
	if input_data.held_actions.has("CROUCH"):
		player.grappling.shorten(-get_process_delta_time())
	super(input_data)

func physics_tick(delta)->void:
	var at_least_one_can_use=false
	for hand in player.grappling.active_grappling_targets:
		var can_use = player.stamina_meters[hand].try_use(stamina_use_per_second*stamina_use_mult*delta)
		if can_use:
			player.grappling.handle_grapple(hand,delta)
			at_least_one_can_use = true
		else:
			player.grappling.retreat(hand)
	if not at_least_one_can_use:
		transition.emit(STATE_STRINGS.IDLE)
	player.move_and_slide()


func _check_transitions(input_data:InputData)->void:
	if not input_data.held_actions.has("ALT_ACTION") and not input_data.held_actions.has("INTERACT"):
		transition.emit(STATE_STRINGS.INAIR)
	super(input_data)
