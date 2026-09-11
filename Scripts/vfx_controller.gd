class_name VFXController
extends Node3D
@export var player: Player

@export var screen_space_vfx: ScreenSpaceVFX

@export var ground_slam_mesh: MeshInstance3D
var shader_mat: ShaderMaterial

func play():
	global_position = player.global_position + Vector3.UP*0.01
	ground_slam_mesh.visible = true
	shader_mat = ground_slam_mesh.get_active_material(0)
	
	var tween = get_tree().create_tween()
	tween.tween_method(func(val):shader_mat.set_shader_parameter("time_seek",val),0.0,1.0,0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.play()
	tween.finished.connect(func():ground_slam_mesh.visible = false)
	pass
