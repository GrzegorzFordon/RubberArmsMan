class_name CameraRotation
extends Node

@export var player: Player
@export var camera_roll: Node3D

@export_range(1,10,1) var mouse_sensitivity = 1
@export var enable_mouse_smoothing:=true
@export var camera_pitch_max := 60
@export var camera_pitch_min := -60
@export var camera_wall_run_roll_deg := 15
var current_look_dir:=Vector2.ZERO

const MOUSE_SENSITIVITY_MULT = 0.001
const CONTROLLER_SENSITIVITY = 0.1

var goal_camera_roll := 0.0

func _process(delta: float) -> void:
	camera_roll.rotation_degrees.z = lerp(camera_roll.rotation_degrees.z,goal_camera_roll,5.0*delta)

func rotate(rotation_x_deg:float,rotation_y_deg:float,is_controller:bool=false):
	var sensitivity = CONTROLLER_SENSITIVITY if is_controller else mouse_sensitivity*MOUSE_SENSITIVITY_MULT
	var dir = Vector2(rotation_x_deg,rotation_y_deg)
	if is_controller or enable_mouse_smoothing:
		if dir.length() < current_look_dir.length():
			current_look_dir = dir
		else:
			current_look_dir = current_look_dir.lerp(dir,5.0*get_process_delta_time()/Engine.time_scale)
	else:
		current_look_dir = dir
	player.camera.rotate_x(-current_look_dir.y*sensitivity)
	player.camera.rotation_degrees.x = clamp(player.camera.rotation_degrees.x,camera_pitch_min,camera_pitch_max)
	player.rotate_y(-current_look_dir.x*sensitivity)

func set_camera_roll(dir):
	goal_camera_roll = camera_wall_run_roll_deg * dir
