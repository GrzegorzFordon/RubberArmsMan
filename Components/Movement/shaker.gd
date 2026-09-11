class_name Shaker
extends Node

@export var is_active:=true
@export var target:Node3D
@export var noise_tex:NoiseTexture2D
@export var max_offset:=0.1
@export var speed:=1.0

var counter:=0.0

func _ready() -> void:
	if not target: target = get_parent()

func _process(delta: float) -> void:
	counter += delta
	var offset_x = noise_tex.noise.get_noise_2d(counter,0)
	var offset_y = noise_tex.noise.get_noise_2d(0,counter)
	var offset = Vector3(offset_x,offset_y,0) * max_offset
	target.position = offset
