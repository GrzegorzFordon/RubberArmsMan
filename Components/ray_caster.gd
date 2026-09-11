class_name RayCaster
extends Node

@export var shape_cast_3d: ShapeCast3D

func get_colliders_of_type_or_null(type:Variant,max_length:float,width:float=0,in_children:bool=false):
	var candidate = null
	var shape_cast_sphere_shape = shape_cast_3d.shape as SphereShape3D
	shape_cast_sphere_shape.radius = max(width,0.01) * 0.5
	shape_cast_3d.target_position = Vector3.FORWARD*max_length
	if not shape_cast_3d.is_colliding(): return null
	return shape_cast_3d.get_collider(0)
	#var collision_count = shape_cast_3d.get_collision_count()
	#for i in collision_count:
		#var collider = shape_cast_3d.get_collider(i)
		#var collider_of_type = is_instance_of(collider,type)
		#var child_of_type = Util.get_child_of_type(collider,type)
		#if child_of_type: candidate = collider if return_parent else child_of_type
	#return candidate
