class_name LerpFollow
extends Node

@export var enable_position:=false
@export var enable_rotation:=false
@export var unscaled_time:=true
@export var body:Node3D
@export var target:Node3D
@export var speed:=5.0
@export var position_offset:Vector3

func _process(delta: float) -> void:
	_update(delta)

func _update(delta:float):
	var offset = position_offset
	var time_scale_mult = 1/Engine.time_scale if unscaled_time else 1.0
	var lerp_position = lerp(body.global_position,target.global_position+offset,speed*delta*time_scale_mult)
	var goal_position = lerp_position if enable_position else target.global_position+offset
	body.global_position = goal_position
	var lerp_transform = body.global_transform.interpolate_with(target.global_transform,speed*delta*time_scale_mult)
	var goal_transform = lerp_transform if enable_rotation else target.global_transform
	body.global_transform = goal_transform
