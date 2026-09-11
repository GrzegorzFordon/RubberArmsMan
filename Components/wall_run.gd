class_name WallRun
extends Node

@export var player: Player

@export var accelleration:=100.0
@export var scale_speed:=10.0
@export var max_speed:=30.0
@export var max_scaling_speed:=30.0
@export var gravity:=5.0
@export var building_shape_cast: ShapeCast3D

func move(delta)->bool:
	var normal = get_shape_cast_collisions()[1]
	var w_dir = Vector3.UP.cross(normal)
	var p_dir = -player.basis.z
	var dot = w_dir.dot(p_dir)
	#print(w_dir)
	if dot < 0:
		w_dir=-w_dir
	#Looking Away
	#var wallrun_axis = Vector2(w_dir.x,w_dir.z)
	#var view_dir_axis = Vector2(p_dir.x,p_dir.z)
	#var angle = wallrun_axis.angle_to(view_dir_axis)
	#if dot <0:
		#angle = -angle
	#angle = rad_to_deg(angle)
	#if angle > 85:
		#return
	#Applying
	#print(dot)
	#if abs(dot)<0.9:
	if player.velocity.y > 0.0:
		player.velocity.y = lerp(player.velocity.y,0.0,0.5*delta)
	player.velocity += w_dir * accelleration * delta
	player.velocity.y -= gravity*delta
	if player.velocity.length()>max_speed:
		player.velocity.limit_length(lerp(player.velocity.length(),max_speed,1.0*delta))
	player.move_and_slide()
	return true

func scale(delta):
	#player.velocity.y = max(player.velocity.y,0.0)
	if player.velocity.y < 0.0:
		player.velocity.y = lerp(player.velocity.y,0.0,5.0*delta)
	player.velocity += Vector3.UP*scale_speed*delta
	player.velocity = player.velocity.limit_length(max_scaling_speed )
	player.move_and_slide()
	return

#Wallrun Helpers

func get_relevant_hand():
	var col = get_shape_cast_collisions()
	if not col: return -1
	var pos = col[0]
	var normal = col[1]
	var w_dir = Vector3.UP.cross(normal)
	var dot = w_dir.dot(-player.global_basis.z)
	var relevant_hand = null
	if dot > 0.2: relevant_hand = Arms.Hand.LEFT
	if dot < -0.2: relevant_hand = Arms.Hand.RIGHT
	return relevant_hand

func get_dot_product_to_wall()->float:
	var col = get_shape_cast_collisions()
	if not col: return -1.0
	var normal = col[1] 
	var w_dir = Vector3.UP.cross(normal)
	var dot = w_dir.dot(-player.camera.global_basis.z)
	return dot

func get_shape_cast_collisions():
	building_shape_cast.force_shapecast_update()
	if building_shape_cast.get_collision_count():
		var pos = building_shape_cast.get_collision_point(0)
		var normal = building_shape_cast.get_collision_normal(0)
		var normal_up_dot = normal.dot(Vector3.UP)
		if normal_up_dot > 0.95: return[]
		return [pos,normal]
	return []

func look_dir_implies_scaling()->bool:
	var sphere_cast_collision = player.wall_run.get_shape_cast_collisions() as Array
	if not sphere_cast_collision:
		return false
	var look_dir = -player.camera.global_basis.z
	var wall_normal = sphere_cast_collision[1]
	var look_up_dot = look_dir.dot(Vector3.UP)
	var w_dir = Vector3.UP.cross(wall_normal)
	var look_at_wall_dir_dot = look_dir.dot(w_dir)
	var is_scaling = look_up_dot > 0.7 and abs(look_at_wall_dir_dot) < 0.2
	return is_scaling
