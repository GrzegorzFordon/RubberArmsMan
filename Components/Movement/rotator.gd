class_name Rotator
extends Node

@export var is_active := true
@export var speed := 10.0
@export var axis := Vector3.ZERO
var target

func _ready() -> void:
	target = get_parent() as Node3D

func _process(delta: float) -> void:
	if not is_active: return
	target.rotation += axis * TAU * speed * delta 
