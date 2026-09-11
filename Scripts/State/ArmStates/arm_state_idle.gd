class_name ArmStateIdle
extends ArmState

func enter(_data=null)->void:
	super()

func exit()->void:
	super()

func tick(_delta)->void:
	super(_delta)

func physics_tick(_delta)->void:
	if arm.active_grappling_target:
		transition.emit(STATE_STRINGS.GRAPPLING)
	super(_delta)

func process_inputs(input_data:InputData)->void:
	_check_transitions(input_data)

func _check_transitions(input_data:InputData)->void:
	pass
