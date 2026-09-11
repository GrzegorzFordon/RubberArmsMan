class_name ArmState
extends State

var arm:Arm

const STATE_STRINGS = {
	"IDLE":"ArmStateIdle",
	"HOLDING":"ArmStateHolding",
	"GRAPPLING":"ArmStateGrappling",
	}

func _ready() -> void:
	arm = owner as Arm

func enter(_data=null)->void:
	#print(Arms.Hand.keys()[arm.hand]," Entering: ",name)
	super()

func exit()->void:
	super()

func tick(_delta)->void:
	super(_delta)

func physics_tick(_delta)->void:
	super(_delta)

func process_inputs(input_data:InputData)->void:
	_check_transitions(input_data)

func _check_transitions(input_data:InputData)->void:
	pass
