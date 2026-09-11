class_name SecurityCamera
extends Node3D

enum CAMERA_STATE {IDLE,TARGET,OFFLINE}

@export var target:Node3D:
	set(val):
		look_at_target.target = val
		target = val

@export var lens_mesh: MeshInstance3D
@export var cone_mesh: MeshInstance3D

@export var idle_color:Color
@export var active_color:Color
@export var offline_color:Color
@export var look_at_target: LookAtTarget

@export var timer: Timer

var state := CAMERA_STATE.IDLE

var tween:Tween

func _ready() -> void:
	timer.timeout.connect(change_state)

func change_state():
	state = CAMERA_STATE.TARGET if state == CAMERA_STATE.IDLE else CAMERA_STATE.IDLE
	var relevant_color = idle_color if state == CAMERA_STATE.IDLE else active_color
	var mat_lens = lens_mesh.get_active_material(0)
	var mat_cone = cone_mesh.get_active_material(0)
	tween = get_tree().create_tween()
	tween.tween_property(mat_lens,"emission",relevant_color,0.2)
	tween.tween_property(mat_cone,"albedo_color",relevant_color,0.2)
