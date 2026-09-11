class_name CombatStateCarrying
extends CombatState

var catenary_target_pos
var carried_object_reached_hand:=false
var target:Node3D

func enter(_data=null)->void:
	#combat.arms.set_interacting(true)
	combat.player.interactor.start_interact()
	target = player.interactor.active_interactable.owner
	#combat.catenary_alt.target_node.global_position = target.global_position
	#combat.arms.set_interact_target_position(target.global_position)
	combat.arms.hold(target)
	super()
	pass

func exit()->void:
	combat.catenary_alt.visible = false
	combat.arms.set_interacting(false)
	carried_object_reached_hand = false
	super()
	pass

func tick(_delta)->void:
	combat.catenary_alt.target_node.global_position = target.global_position
	#combat.arms.set_interact_target_position(target.global_position)
	var item_distance_to_hand = target.global_position.distance_to(player.hand_marker_left.global_position)
	if not carried_object_reached_hand and item_distance_to_hand < 0.1:
		carried_object_reached_hand = true
		player.camera_effects.add_damage_kick(10,10,player.global_position-player.head.global_basis.z)
	super(_delta)
	pass


func _check_transitions(input_data:InputData)->void:
	super(input_data)
	if not input_data.held_actions.has("INTERACT"):
		transition.emit(STATE_STRINGS.IDLE)
	pass
