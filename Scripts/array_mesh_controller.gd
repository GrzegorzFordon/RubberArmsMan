@tool
class_name ArrayMeshController
extends Node3D

@export var mesh_instance: MeshInstance3D

#Immediate Mesh
@export var radius_top:=10.0
@export var radius_bottom:=10.0
@export var segments:=12
@export var height:=50.0

var vertices = PackedVector3Array()
var normals = PackedVector3Array()

func _process(delta: float) -> void:
	vertices.clear()
	var mesh = mesh_instance.mesh as ArrayMesh
	mesh.clear_surfaces()
	_draw_cylinder()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP,arrays)

func _draw_cylinder():
	var angle = 0.0
	var step = TAU / segments
	var half_height = height * 0.5

	for i in segments+1:
		var s = sin(angle)
		var c = cos(angle)
		var top_circle_vertice_vector = global_basis * Vector3(s*radius_top,c*radius_top,0)+global_position
		var bottom_circle_vertice_vector = global_basis * Vector3(s*radius_bottom,c*radius_bottom,-height)+global_position
		var ray_result = _shoot_ray_cast(top_circle_vertice_vector,bottom_circle_vertice_vector)
		vertices.append(top_circle_vertice_vector)
		vertices.append(ray_result)
		angle += step

func _shoot_ray_cast(origin:Vector3,goal:Vector3)->Vector3:
	var space_rid = get_world_3d().direct_space_state
	var angle = origin.angle_to(goal)
	var query = PhysicsRayQueryParameters3D.create(origin,goal,8)
	var result = space_rid.intersect_ray(query)
	if result: return result.position
	else:return goal
