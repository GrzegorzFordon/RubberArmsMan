class_name EnemyStateIdle
extends EnemyState

func physics_tick(_delta)->void:
	if enemy.hit_receiver.active_hit_data:
		transition.emit(STATE_STRINGS.HITREACT)
		return
	super(_delta)
