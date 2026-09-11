class_name Projectile
extends Node3D

var hit_box: HitBox

var velocity:Vector3
var hit_data:HitData

func with_data(_veloctiy:Vector3,_hit_data:HitData)->Projectile:
	velocity = _veloctiy
	hit_data = _hit_data
	return self

func _ready() -> void:
	hit_box = Util.get_child_of_type(self,HitBox)
	hit_box.hurt_box_hit.connect(_on_hit)
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func _on_hit(hurt_box:HurtBox):
	hurt_box.on_hit(hit_data)
	#print(hurt_box.owner.name)
	queue_free()
