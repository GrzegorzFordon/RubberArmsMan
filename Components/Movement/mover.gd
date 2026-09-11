class_name Mover
extends Node

@export var is_active:=true
@export var target:Node3D
@export var axis_vector:Vector3
@export var speed:=1.0
@export var min_val:float
@export var max_val:float
@export var curve:Curve
@export var noise_tex:Noise
@export var start_random:bool

var base_val:Vector3
var cur_time:=0.0

func _ready() -> void:
	if not target:
		target = get_parent()
	base_val = target.global_position
	if start_random: cur_time += randf()

func _process(delta: float) -> void:
	if is_active:
		cur_time += delta*speed
		cur_time = fmod(cur_time,1.0)
		var curve_val = curve.sample(cur_time)
		var cur_val = remap(curve_val,0,1,min_val,max_val)
		if noise_tex:
			var noise_val = noise_tex.get_noise_1d(cur_time)
			cur_val += noise_val
		var cur_val_vector = axis_vector * cur_val
		target.global_position = base_val + cur_val_vector
