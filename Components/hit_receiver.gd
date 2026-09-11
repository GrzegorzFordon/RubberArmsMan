class_name HitReceiver
extends Node

var body : PhysicsBody3D
var current_force:Vector3
var active_hit_data : HitData

func _ready() -> void:
	body = owner

func _on_hit(hit_data: HitData) -> void:
	active_hit_data = hit_data
	#var direction = hit_data.origin.direction_to(body.global_position)
