class_name Panner
extends Node

@export var is_active:=true
@export var target:Node3D
@export var axis_vector:Vector3
@export var speed:=1.0
@export var min_angle:float
@export var max_angle:float
@export var curve:Curve
@export var noise_tex:Noise
@export var start_random:bool
var base_rot:Vector3
var cur_val:=0.0

func _ready() -> void:
	if not target:
		target = get_parent()
	base_rot = target.global_rotation_degrees
	if start_random: cur_val += randf()

func _process(delta: float) -> void:
	if is_active:
		cur_val += delta * speed
		cur_val = fmod(cur_val,1.0)
		var sin_val = sin(cur_val)
		sin_val = curve.sample(cur_val)
		var cur_angle = remap(sin_val,-1,1,min_angle,max_angle)
		if noise_tex:
			var noise_val = noise_tex.get_noise_1d(cur_val)
			cur_angle += noise_val
		var cur_rot_vec = axis_vector * cur_angle
		target.global_rotation_degrees = base_rot + cur_rot_vec
