class_name BuildingBase
extends Node3D

@export var roof_light: PackedScene
@export var building_data:BuildingData

@export var mesh_instance: MeshInstance3D
@export var outline_mesh_instance: MeshInstance3D
@export var collision_shape_3d: CollisionShape3D
@export var lights: Node3D
@export var windows: Node3D

func _ready() -> void:
	if building_data: set_up(building_data)

func set_up(_data:BuildingData):
	building_data = _data
	set_meshes(building_data)
	set_collisions(building_data)
	set_lights(building_data)

func set_meshes(building_data:BuildingData):
	mesh_instance.mesh = building_data.mesh
	outline_mesh_instance.mesh = building_data.outline_mesh
	var mesh_shader_mat = mesh_instance.get_active_material(0) as ShaderMaterial
	var outline_mesh_shader_mat = outline_mesh_instance.get_active_material(0) as StandardMaterial3D
	mesh_shader_mat.set_shader_parameter("ColorParameter",building_data.color_arr.pick_random())
	outline_mesh_shader_mat.set("albedo_color",building_data.outline_color_arr.pick_random())
	windows.visible = building_data.show_windows

func set_collisions(building_data:BuildingData):
	var box_shape = collision_shape_3d.shape as BoxShape3D
	box_shape.size = building_data.collision_box_size
	collision_shape_3d.position.y = building_data.collision_box_size.y * 0.5

func set_lights(building_data:BuildingData):
	for light_pos in building_data.light_pos_arr:
		var new_light = roof_light.instantiate() as Node3D
		lights.add_child(new_light)
		new_light.position = light_pos
