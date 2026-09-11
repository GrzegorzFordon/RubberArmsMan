class_name CombatStateIdle
extends CombatState

func enter(_data=null)->void:
	super()
	pass

func exit()->void:
	super()
	pass

func tick(_delta)->void:
	super(_delta)
	pass

func physics_tick(_delta)->void:
	super(_delta)
	pass

func process_inputs(input_data:InputData)->void:
	super(input_data)
	pass

func _check_transitions(input_data:InputData)->void:
	super(input_data)
	if input_data.just_pressed_actions.has("INTERACT"):
		if player.interactor.has_candidate():
			transition.emit(STATE_STRINGS.CARRYING)
		elif combat.has_target():
			transition.emit(STATE_STRINGS.ATTACHED)
	pass
