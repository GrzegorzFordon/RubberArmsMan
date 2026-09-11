class_name EnemyStateHitReact
extends EnemyState

const WEAK_HIT_ANIMATION_NAME = "Hit_Chest"
const STRONG_HIT_ANIMATION_NAME = "hit_knockback_anim/Hit_Knockback"

var hit_data

func enter(_data=null)->void:
	super(_data)
	hit_data = enemy.hit_receiver.active_hit_data
	enemy.hit_receiver.active_hit_data = null
	var had_armor = enemy.armor_meter.try_use(30)
	var hit_amount = hit_data.power * (0.2 if had_armor else 1.0)
	enemy.health_meter.try_use(hit_amount)

func tick(_delta)->void:
	enemy.hit_react_ik.update(_delta)
	if enemy.hit_react_ik.spring_velocity.length() < 0.001:
		enemy.hit_react_ik.spring_velocity = Vector3.ZERO
		transition.emit(STATE_STRINGS.IDLE)
		return
	super(_delta)

func physics_tick(_delta)->void:
	if enemy.hit_receiver.active_hit_data != null:
		transition.emit(STATE_STRINGS.HITREACT)
	super(_delta)
	_lerp_look_at_force(_delta)
	enemy.velocity = enemy.hit_receiver.current_force * _delta
	enemy.movement.move(Vector3.ZERO,Movement.MOVE_TYPE.RUN)
	enemy.movement.handle_gravity()

func _lerp_look_at_force(delta:float):
	if(enemy.force_receiver.current_force.length()<0.2):return
	var force_direction = enemy.global_position + enemy.force_receiver.current_force.normalized()
	var look_at_val = Vector3(force_direction.x,enemy.global_position.y,force_direction.z)
	var new_transform = enemy.global_transform.looking_at(look_at_val)
	enemy.global_transform = enemy.global_transform.interpolate_with(new_transform,2.0*delta)
