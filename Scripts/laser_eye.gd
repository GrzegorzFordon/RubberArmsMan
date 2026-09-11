extends CharacterBody3D

@export var player:Player
@export var shape_cast_3d: ShapeCast3D
@export var timer: Timer

var last_pos:Vector3
var is_active:=true
@export var interactable: Interactable

var scale_tween : Tween

func _ready() -> void:
	#var interactable = Util.get_child_of_type(self,Interactable) as Interactable
	interactable.interact_started.connect(func(x):_on_interact(true))
	interactable.interact_ended.connect(func(x):_on_interact(false))

func _physics_process(delta: float) -> void:
	move_and_slide()
	if not is_active: return
	_update()
	var look_at_transform = transform.looking_at(last_pos+Vector3.UP)
	transform = transform.interpolate_with(look_at_transform,5.0*delta)

func _update():
	shape_cast_3d.look_at(player.global_position)
	if shape_cast_3d.is_colliding():
		if shape_cast_3d.get_collider(0) is Player:
			last_pos = player.position

func _on_interact(is_interacting:bool):
	is_active = !is_interacting
	var goal_scale = 0.1 if is_interacting else 1.0
	var duration = 0.2 if is_interacting else 0.05
	if scale_tween and scale_tween.is_running(): scale_tween.stop()
	scale_tween = get_tree().create_tween()
	scale_tween.tween_property(self,"scale",Vector3.ONE * goal_scale,duration).set_trans(Tween.TRANS_BACK)
	scale_tween.play()
