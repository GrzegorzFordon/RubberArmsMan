class_name CameraEffects
extends Node

@export var player: Player

@export var enable_tilt:bool
@export var enable_fall_kick:bool
@export var enable_damage_kick:bool
@export var enable_velocity_fov:bool

#tilt
@export var run_pitch:=0.1
@export var run_roll:=0.25
@export var max_pitch:=1.0
@export var max_roll:=2.5

#fall kick
@export var fall_time:=0.2

#damage kick
@export var damage_time:=0.3

#velocity fov
@export var base_fov:=75.0
@export var fov_change := 1.5

var _fall_value := 0.0
var _fall_timer := 0.0

var _damage_pitch := 0.0
var _damage_roll := 0.0
var _damage_timer := 0.0

func add_fall_kick(fall_strength:float):
	#print("Fall Kick (Strength:",fall_strength,")")
	_fall_value = deg_to_rad(fall_strength)
	_fall_timer = fall_time

func add_damage_kick(pitch:float,roll:float,source:Vector3):
	var forward = player.global_basis.z
	var right = player.global_basis.x
	var direction = player.global_position.direction_to(source)
	var forward_dot = direction.dot(forward)
	var right_dot = direction.dot(right)
	_damage_pitch = deg_to_rad(pitch)*forward_dot
	_damage_roll = deg_to_rad(roll)*right_dot
	_damage_timer = damage_time

func _process(delta: float) -> void:
	_calculate_view_offset(delta)
	if enable_velocity_fov: _update_camera_fov(delta)

func _calculate_view_offset(delta:float):
	if not player:return
	var velocity = player.velocity
	var angles = Vector3.ZERO
	var offset = Vector3.UP*player.head_height
	_fall_timer -= delta
	_damage_timer -= delta
	if enable_tilt:
		var forward = player.global_transform.basis.z
		var right = player.global_transform.basis.x

		var forward_dot = velocity.dot(forward)
		var forward_tilt = clampf(forward_dot*deg_to_rad(run_pitch),deg_to_rad(-max_pitch),deg_to_rad(max_pitch))
		angles.x += forward_tilt

		var right_dot = velocity.dot(right)
		var side_tilt = clampf(right_dot*deg_to_rad(run_roll),deg_to_rad(-max_roll),deg_to_rad(max_roll))
		angles.z -= side_tilt

	if enable_fall_kick:
		var fall_ratio = max(0.0,_fall_timer/fall_time)
		var fall_kick_amount = fall_ratio * _fall_value
		angles.x -= fall_kick_amount
		offset.y -= fall_kick_amount * 2.0

	if enable_damage_kick:
		var damage_ratio = max(0.0,_damage_timer/damage_time)
		angles.x -= damage_ratio * _damage_pitch
		angles.z -= damage_ratio * _damage_roll

	player.head.position = lerp(player.head.position,offset,5.0*delta)
	player.head.rotation = lerp(player.head.rotation,angles,5.0*delta)

func _update_camera_fov(delta:float):
	var target_fov = base_fov
	# Velocity
	var clamped_velocity = clamp(player.velocity.length()-15,0.0,50)
	target_fov += fov_change * clamped_velocity
	
	#Time Slow
	var time_scale = Engine.time_scale
	time_scale = remap(time_scale,1,0,0,1)
	target_fov += time_scale * -20.0
	#print(time_scale)
	
	player.camera.fov = lerp(player.camera.fov,target_fov,8.0*delta)
