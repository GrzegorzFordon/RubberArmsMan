class_name ArmStateWallRun
extends ArmState

func enter(_data=null)->void:
	super()

func exit()->void:
	super()

func tick(_delta)->void:
	super(_delta)

func physics_tick(_delta)->void:
	#arm.copy_transform_modifier.set
	super(_delta)

func process_inputs(input_data:InputData)->void:
	_check_transitions(input_data)

func _check_transitions(input_data:InputData)->void:
	pass
