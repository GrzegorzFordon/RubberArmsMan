@tool
class_name BuildingsSystem
extends Node3D

@export var color_arr:Array[Color]
@export var static_body: StaticBody3D

@export var run:bool:
	set=_add_collisions
@export var randomize_color:bool:
	set=_randomize_color
@export var randomize_scale:bool:
	set=_randomize_scale

func _ready() -> void:
	_randomize_color()
	_randomize_scale()
	_add_collisions()

func _add_collisions(_b=null):
	static_body = Util.get_child_of_type(self,StaticBody3D) as StaticBody3D
	for child in static_body.get_children():
		if not is_instance_of(child,GrapplingTarget):
			child.call_deferred("queue_free")
	var paths = get_children().filter(func(val):return is_instance_of(val,PathMultiMesh3D))
	for path in paths:
		var multi_mesh = path.multi_mesh as MultiMesh
		var shape = multi_mesh.mesh.create_trimesh_shape() as Shape3D
		#var shape_aabb = multi_mesh.mesh.get_aabb()
		#var shape = BoxShape3D.new() as BoxShape3D
		#shape.size = shape_aabb.size
		#shape.size.y = shape_aabb.size.y * 2
		for mesh_index in multi_mesh.instance_count:
			var transform = multi_mesh.get_instance_transform(mesh_index)
			var col_shape = CollisionShape3D.new()
			static_body.add_child(col_shape)
			col_shape.owner = get_tree().edited_scene_root
			col_shape.shape = shape
			col_shape.transform = transform

func _randomize_color(_b=null):
	var paths = get_children().filter(func(val):return is_instance_of(val,PathMultiMesh3D))
	for path in paths:
		var multi_mesh = path.multi_mesh as MultiMesh
		for mesh_index in multi_mesh.instance_count:
			var rid = multi_mesh.get_rid()
			#RenderingServer.multimesh_instance_set_color(rid,mesh_index,color_arr.pick_random())
			multi_mesh.set_instance_color(mesh_index,color_arr.pick_random())

func _randomize_scale(_b=null):
	var paths = get_children().filter(func(val):return is_instance_of(val,PathMultiMesh3D))
	for path in paths:
		var multi_mesh = path.multi_mesh as MultiMesh
		for mesh_index in multi_mesh.instance_count:
			var rid = multi_mesh.get_rid()
			var transform = RenderingServer.multimesh_instance_get_transform(rid,mesh_index)
			transform = transform.scaled_local(Vector3.ONE*randf_range(0.9,1.1))
			#RenderingServer.multimesh_instance_set_transform(rid,mesh_index,transform)
			multi_mesh.set_instance_transform(mesh_index,transform)




	#static_body = StaticBody3D.new()
	#static_body.set_collision_layer_value(8,true)
	#add_child(static_body)
	#static_body.owner = get_tree().edited_scene_root
	#var grappling_target = GrapplingTarget.new()
	#static_body.add_child(grappling_target)
	#grappling_target.owner = get_tree().edited_scene_root
