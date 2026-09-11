class_name PlayerStateSlide
extends PlayerState

func enter(_data=null)->void:
	super(_data)
	pass

func exit()->void:
	super()
	pass

func tick(_delta)->void:
	super(_delta)
	pass

func _check_transitions(input_data:InputData)->void:
	if input_data.just_pressed_actions.has("ALT_ACTION"):
		if player.grappling.has_target() or player.grappling.hit_sky:
			transition.emit(STATE_STRINGS.GRAPPLING)
	super(input_data)
	pass
