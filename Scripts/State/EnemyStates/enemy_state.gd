class_name EnemyState
extends State

@export var animation_name:String
@export var animation_is_one_shot:bool
@export var animation_is_top_only:bool

var enemy : Enemy

const STATE_STRINGS = {
	"IDLE":"EnemyStateIdle",
	"HITREACT":"EnemyStateHitReact",
	"DEAD":"EnemyStateDead",
	}

func enter(_data=null)->void:
	enemy = owner
	enemy.state_label.text = name.trim_prefix("EnemyState")
	_play_animation()
	super(_data)

func exit()->void:
	super()

func tick(_delta)->void:
	if enemy.health_meter.is_empty():
		transition.emit(STATE_STRINGS.DEAD)
		return
	super(_delta)

func physics_tick(_delta)->void:
	super(_delta)

func _play_animation():
	if animation_name == "":return
	if not enemy: return
	enemy.animation_tree_controller.set_animation(animation_name,animation_is_top_only,animation_is_one_shot)
