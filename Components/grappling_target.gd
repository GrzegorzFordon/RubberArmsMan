class_name GrapplingTarget
extends Node

@export var parent:Node3D
@export var is_static:=true

var local_offset:=Vector3.ZERO

func _ready() -> void:
	if not parent: parent = owner as Node3D

func on_hit(hit_position:Vector3):
		local_offset = hit_position - parent.global_position

func get_world_pos_with_offset():
	return parent.global_position + local_offset

#func get_height()->float:
	#var space_state = parent.get_world_3d().direct_space_state
	#var query = PhysicsRayQueryParameters3D.create(parent.global_position,parent.global_position-Vector3(0,-100,0),1)
	#var result = space_state.intersect_ray(query)
	#var height = parent.global_position.y
	#if result:
		#height = result.position.y-parent.global_position.y
	#return height
