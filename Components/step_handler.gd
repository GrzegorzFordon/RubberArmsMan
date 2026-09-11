class_name StepHandler
extends Node

@export var player: Player
@export var camera_smoothing: Node3D

@export var surface_treshold:=0.3
@export var step_height:=0.5

var _cached_camera_global_position

func _save_camera_pos_for_smoothing():
	if  _cached_camera_global_position == null:
		_cached_camera_global_position = camera_smoothing.global_position

func _process(delta: float) -> void:
	slide_camera_smooth_back_to_origin(delta)

func slide_camera_smooth_back_to_origin(delta:float):
	if  _cached_camera_global_position == null: return
	camera_smoothing.global_position.y = _cached_camera_global_position.y
	camera_smoothing.position.y = clampf(camera_smoothing.position.y,-.7,.7)
	var move_amount = max(player.velocity.length(),2.5)*delta
	camera_smoothing.position.y = move_toward(camera_smoothing.position.y,0.0,move_amount)
	_cached_camera_global_position = camera_smoothing.global_position
	if camera_smoothing.position.y == 0.0:
		_cached_camera_global_position = null

func handle_step_climbing(direction):
	for i in player.get_slide_collision_count():
		var collision = player.get_slide_collision(i)
		if _is_vertical_surface(collision):
			#print("Vertical Collision Found!", collision.get_normal())
			var measured_height = _measure_step_height(collision)
			if measured_height > 0 and measured_height <= step_height and _is_valid_step_direction(collision,direction):
				_save_camera_pos_for_smoothing()
				player.global_position.y += measured_height
				player.velocity = player.cached_velocity

func _is_vertical_surface(collision:KinematicCollision3D):
	var normal = collision.get_normal()
	if abs(normal.y)<=surface_treshold:
		return true
	return _check_collision_surface(collision)

func _check_collision_surface(collision:KinematicCollision3D):
	var space_state = player.get_world_3d().direct_space_state
	var collision_point = collision.get_position()
	var player_feet = _get_player_feet_position()
	collision_point.y = player_feet.y
	var query = PhysicsRayQueryParameters3D.create(player_feet,collision_point)
	query.collision_mask = player.collision_mask
	query.exclude = [player.get_rid()]
	var result = space_state.intersect_ray(query)
	if result and abs(result.normal.y)<= surface_treshold:
		return true
	else: return false

func _get_player_feet_position()->Vector3:
	var feet_pos = player.global_position
	feet_pos.y += 0.05
	return feet_pos

func _measure_step_height(collision:KinematicCollision3D)->float:
	var space_state = player.get_world_3d().direct_space_state
	var collision_point = collision.get_position()
	var player_feet = _get_player_feet_position()
	var player_head_y = player.head.global_position.y
	var ray_start = Vector3(collision_point.x,player_head_y,collision_point.z)
	var ray_end = Vector3(collision_point.x,player_feet.y,collision_point.z)
	var query = PhysicsRayQueryParameters3D.create(ray_start,ray_end)
	query.collision_mask = player.collision_mask
	query.exclude = [player.get_rid()]
	var result = space_state.intersect_ray(query)
	if result:
		return result.position.y - player_feet.y
	return 0.0
	pass

func _is_valid_step_direction(collision:KinematicCollision3D,direction):
	var collision_normal = collision.get_normal()
	var move_dir = direction
	if move_dir:
		move_dir = move_dir.normalized()
		var dot_product = move_dir.dot(-collision_normal)
		return dot_product > 0.5
	return false
