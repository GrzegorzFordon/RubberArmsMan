class_name Crouching
extends Node

@export var player: Player
signal crouching_changed(is_crouching:bool)

#Crouching
@export var collision_shape_3d: CollisionShape3D
@export var mesh_instance_3d: MeshInstance3D

var is_crouching:=false

func set_crouch(_is_crouching:bool):
	is_crouching = _is_crouching
	crouching_changed.emit(is_crouching)
	var col_shape = collision_shape_3d.shape as CapsuleShape3D
	var mesh_shape = mesh_instance_3d.mesh as CapsuleMesh
	col_shape.height = 1 if is_crouching else 2
	mesh_shape.height = 1 if is_crouching else 2
	collision_shape_3d.position.y = col_shape.height * 0.5
	mesh_instance_3d.position.y = mesh_shape.height * 0.5
	player.head_height = 0.5 if is_crouching else 1.5
