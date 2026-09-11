@tool
class_name Rope
extends Node3D

@export var anchor_start: StaticBody3D
@export var anchor_end: StaticBody3D
@export var pieces_parent: Node3D

@export var piece_amount:=10
@export var piece_length:=0.3
@export var piece_radius:=0.05


func _ready() -> void:
	_generate_rope()

func _generate_rope():
	pass

func _create_piece():
	pass
