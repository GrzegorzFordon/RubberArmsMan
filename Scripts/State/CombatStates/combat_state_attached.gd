class_name CombatStateAttached
extends CombatState

var catenary_target_pos
var target:Enemy

func enter(_data=null)->void:
	combat.catenary_alt.visible = true
	target = combat.get_target()
	catenary_target_pos = target.global_position + Vector3.UP*1.5
	combat.catenary_alt.target_node.global_position = combat.catenary_alt.global_position
	super()
	pass

func exit()->void:
	combat.catenary_alt.visible = false
	var enemy_hurt_box = Util.get_child_of_type(target,HurtBox) as HurtBox
	if enemy_hurt_box:
		var hit_data = HitData.new().with_data(combat.player.global_position,1000)
		get_tree().create_timer(0.2).timeout.connect(func():enemy_hurt_box.on_hit(hit_data))
	super()
	pass

func tick(_delta)->void:
	super(_delta)
	combat.catenary_alt.target_node.global_position = combat.catenary_alt.target_node.global_position.move_toward(catenary_target_pos,55.0*_delta)
	pass

func physics_tick(_delta)->void:
	super(_delta)
	pass

func process_inputs(input_data:InputData)->void:
	super(input_data)
	pass

func _check_transitions(input_data:InputData)->void:
	super(input_data)
	if not input_data.held_actions.has("INTERACT"):
		transition.emit(STATE_STRINGS.IDLE)
	pass
