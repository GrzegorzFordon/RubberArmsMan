class_name LookAtTarget
extends Node

@export var parent : Node3D
@export var target : Node3D

func _process(delta: float) -> void:
	if parent and target:
		parent.look_at(target.global_position)
