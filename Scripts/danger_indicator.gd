class_name DangerIndicator
extends Node3D

@export var panel: Control

var camera:Camera3D
var viewport_center
var border_offset:=Vector2(32,32)
var max_reticle_pos

@export var texture_rect: TextureRect
@export var label: Label

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	set_window_size()
	get_viewport().size_changed.connect(set_window_size)

func _process(delta: float) -> void:
	panel.visible = !camera.is_position_in_frustum(global_position)
	var local_to_camera = camera.to_local(global_transform.origin)
	var reticle_pos = Vector2(local_to_camera.x,-local_to_camera.y)
	if reticle_pos.abs().aspect() > max_reticle_pos.aspect():
		reticle_pos *= max_reticle_pos.x / abs(reticle_pos.x)
	else:
		reticle_pos *= max_reticle_pos.y / abs(reticle_pos.y)
	panel.set_global_position(viewport_center + reticle_pos-panel.size*0.5)
	var angle = Vector2.UP.angle_to(reticle_pos)
	panel.rotation = angle
	#label.rotation = -angle"offset_transform_rotation"
	label.offset_transform_rotation = -angle

func set_color(color:Color):
	texture_rect.modulate = color
	label.modulate = color

func set_distance(dist:int):
	label.text = str(dist)

func set_window_size():
	viewport_center = Vector2(get_viewport().get_visible_rect().size) * 0.5
	max_reticle_pos = viewport_center - border_offset
