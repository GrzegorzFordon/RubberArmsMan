class_name EnemyStateDead
extends EnemyState

func enter(_data=null)->void:
	super(_data)
	enemy.hit_react_ik.influence = 0
	enemy.weapon_ik.influence = 0
	enemy.weapon_parent.visible = false
	enemy.bars.visible = false
	enemy.state_label.text = ""
