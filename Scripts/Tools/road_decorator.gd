@tool
class_name RoadDecorator
extends Node

@export var mesh:Mesh
@export var road_decoration_parent: Node3D
@export var road_container: RoadContainer
@export var path_mesh_3d: PathMesh3D
@export var root_node: Node3D

@export var run:bool:
	set=_decorate

func _decorate(_b):
	var road_points:Array[RoadPoint]
	var relevant_path_names = ["edge_R","edge_F"]
	var path_mesh = PathMesh3D.new()
	path_mesh.mesh = mesh
	for child in road_container.get_children():
		if child is RoadPoint: road_points.append(child)
	var relevant_paths:Array[Path3D]
	for road_point in road_points:
		var road_point_children = road_point.get_children()
		for road_point_child in road_point_children:
			if relevant_path_names.has(road_point_child.name):
				relevant_paths.append(road_point_child)
	#print(relevant_paths)
	for path in relevant_paths:
		var new_path = path_mesh_3d.duplicate()
		print(new_path)
		new_path.path_3d = path
		#new_path.reparent(road_decoration_parent)
		road_decoration_parent.add_child(new_path)
		new_path.owner = root_node
