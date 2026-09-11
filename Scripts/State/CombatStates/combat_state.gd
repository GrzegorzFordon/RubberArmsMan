class_name CombatState
extends State

@export var combat: Combat
var player:Player

const STATE_STRINGS = {
	"IDLE":"CombatStateIdle",
	"CARRYING":"CombatStateCarrying",
	"ATTACHED":"CombatStateAttached",
	}

func _ready() -> void:
	player = combat.player

func enter(_data=null)->void:
	super()
	player.combat_state_label.text = name

func exit()->void:
	super()

func tick(_delta)->void:
	super(_delta)

func physics_tick(_delta)->void:
	super(_delta)

func process_inputs(input_data:InputData)->void:
	_check_transitions(input_data)

func _check_transitions(input_data:InputData)->void:
	#if input_data.just_pressed_actions.has("INTERACT"):
		#if player.interactor.has_candidate():
			##player.interactor.start_interact()
			#pass
		#else:
			#player.combat.shoot_projectile()
	if not input_data.held_actions.has("INTERACT"):
		if player.interactor.active_interactable:
			player.combat.shoot_projectile(player.interactor.active_interactable.owner)
			player.interactor.stop_interact()
