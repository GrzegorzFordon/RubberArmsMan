class_name ArmStateGrappling
extends ArmState

func enter(_data=null)->void:
	arm.set_copy_amount(1)
	super()

func exit()->void:
	arm.set_copy_amount(0)
	super()

func tick(_delta)->void:
	super(_delta)

func physics_tick(_delta)->void:
	_update_grappling_visuals()
	if not arm.active_grappling_target:
		transition.emit(STATE_STRINGS.IDLE)
		return
	arm.target_marker.global_position = arm.active_grappling_target.get_world_pos_with_offset()
	super(_delta)

func process_inputs(input_data:InputData)->void:
	_check_transitions(input_data)

func _check_transitions(input_data:InputData)->void:
	pass

func _update_grappling_visuals():
	return
	var goal_pos = arm.active_grappling_target.get_world_pos_with_offset()
	var fraction = 0.5
