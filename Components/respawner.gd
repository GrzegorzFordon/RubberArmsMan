class_name Respawner
extends Node

@export var enabled:=false
@export var target:Node3D
@export var respawn_position:Vector3

signal respawned()

func _ready() -> void:
	if not target:
		target = get_parent()

func _process(delta: float) -> void:
	if not target or not enabled:return
	if target.global_position.y < -50:
		respawned.emit()
		target.global_position = respawn_position
