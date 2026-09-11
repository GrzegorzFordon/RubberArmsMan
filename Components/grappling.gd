class_name Grappling
extends Node


@export var player: Player
@export var grappling_shape_cast: ShapeCast3D
@export var audio_stream_player_3d: AudioStreamPlayer3D
#@export var arms: Arms

@export var launch_sfx: AudioStream
@export var retreat_sfx: AudioStream

@export var launch_duration:=0.2
@export var target_offset := 2.25

var is_active_arr:Array[Arms.Hand]
var active_grappling_targets:Dictionary[Arms.Hand,GrapplingTarget]
var active_grapple_durations:Dictionary[Arms.Hand,float]
#var normal

@export var hit_sky := true
@export var sky_ball: MeshInstance3D
@export var shortening_speed:=10.0

#Spring
@export var stiffness := 10.0
@export var damping := 1.0
var cur_stiffness:=0.0
var stiffness_push_amount:=2.0
var stiffness_decay:=1.0

#Forces
@export var gravity = -10
@export var max_speed:=50.0

@export var tension_strength:=10.0
@export var facing_strength:=10.0
@export var floor_push_force_strength:=10.0
@export var floor_push_force_max_length:=10.0
@export var building_push_force_strength:=10.0
@export var building_push_force_mult:=1.0

var rope_length_tweens:Dictionary[Arms.Hand,Tween]
var sky_ball_scale_tween:Tween

var rest_lengths : Dictionary[Arms.Hand,float]
var building_push_shape:SphereShape3D
var building_push_radius:=25.0

func _ready() -> void:
	building_push_shape = SphereShape3D.new()
	building_push_shape.radius = building_push_radius
	cur_stiffness = stiffness
	for hand in Arms.Hand.values():
		active_grapple_durations[hand] = 0.0

func _physics_process(delta: float) -> void:
	var pos = Util.get_child_of_type(sky_ball,GrapplingTarget).get_world_pos_with_offset()
	#print(pos)
	_set_relevant_cross_hair()
	_decay_stiffness(delta)
	#if is_active_arr:
		#handle_grapple(delta)
		#_check_player_behind_target()

func launch(hand:Arms.Hand):
	if active_grappling_targets.has(hand):return
	var col_point = null
	if has_target():
		var col_result = grappling_shape_cast.get_collider(0)
		col_point = grappling_shape_cast.get_collision_point(0)
		#normal = grappling_shape_cast.get_collision_normal(0)
		active_grappling_targets[hand] = Util.get_child_of_type(col_result,GrapplingTarget)
	elif hit_sky:
		col_point = player.global_position - player.camera.global_basis.z * 40
		sky_ball.global_position = col_point
		active_grappling_targets[hand] = Util.get_child_of_type(sky_ball,GrapplingTarget)
		_set_sky_ball_visibility(true)
	if col_point:
		active_grappling_targets[hand].on_hit(col_point)
		rest_lengths[hand] = max(player.global_position.distance_to(col_point) - 2,10.0)
		var original_hit_distance = player.global_position.distance_to(col_point)
		original_hit_distance = max(original_hit_distance,10.0)
		var original_hit_target_height = _get_distance_from_hit_to_ground(col_point)
		if original_hit_target_height < original_hit_distance:
			shorten_to_height(hand,original_hit_target_height)
		is_active_arr.append(hand)
		var dist_to_target = player.global_position.distance_to(active_grappling_targets[hand].get_world_pos_with_offset())
		_play_sound(true)

func retreat(hand:Arms.Hand):
	if not is_active_arr.has(hand):return
	is_active_arr.erase(hand)
	var dist_to_target = player.global_position.distance_to(active_grappling_targets[hand].get_world_pos_with_offset())
	#arms.set_grappling_target(null,null,launch_duration,hand)
	player.arms.set_arm_action(hand,Arm.Action.IDLE)
	active_grapple_durations[hand] = 0.0
	active_grappling_targets.erase(hand)
	_set_sky_ball_visibility(false)
	_play_sound(false)

func handle_grapple(hand:Arms.Hand, delta:float):
	var force = Vector3.ZERO
	force += _get_facing_force()
	force += _get_building_push_force()
	force += _get_floor_push_force()
	if not active_grappling_targets.has(hand):return
	active_grapple_durations[hand] += delta
	var target = active_grappling_targets[hand].get_world_pos_with_offset()
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	var target_dir_with_offset = player.global_position.direction_to(target+Vector3.UP*target_offset)
	var target_dist_with_offset = player.global_position.distance_to(target+Vector3.UP*target_offset)
	player.rest_length_label.text = "Rest Length: "+ str(rest_lengths[hand] as int)
	player.target_dist_label.text = "Target Dist: "+ str(target_dist_with_offset as int)
	var distance_factor = get_fraction(hand)
	if distance_factor<1.0: return
	force += _get_spring_force(target_dist_with_offset,target_dir_with_offset,hand)
	force += _get_tension_force(target_dist_with_offset,target_dir_with_offset,hand)
	force.y += gravity
	player.velocity += force * delta
	player.velocity = player.velocity.limit_length(max_speed)

func _get_tension_force(dist:float,dir:Vector3,hand:Arms.Hand)->Vector3:
	if dist < rest_lengths[hand]: return Vector3.ZERO
	var target = active_grappling_targets[hand].get_world_pos_with_offset()
	var theta=player.global_basis.y.angle_to(-player.to_local(target))
	var sin_theta=sin(theta)
	var cos_theta=cos(theta)
	var tension_force = gravity * cos_theta * tension_strength
	var pendulum_side_dir = (player.global_basis.x * dir).normalized()
	pendulum_side_dir *= Vector3(1,0,1)
	var tangent_dir = (-dir.cross(pendulum_side_dir)).normalized()
	var centripetal_force = pow(player.velocity.length(),2)/max(dist,0.1)
	tension_force += centripetal_force
	player.tension_label.text ="Tension: "+ str(tension_force as int)
	return dir * tension_force

func _get_facing_force()->Vector3:
	var camera_dir = -player.camera.global_basis.z
	var dot = player.velocity.dot(camera_dir)
	dot = clamp(dot,0.5,1.0)
	player.facing_label.text ="Facing: "+ str((camera_dir * facing_strength * dot).length() as int)
	return camera_dir * facing_strength * dot

func _get_building_push_force()->Vector3:
	var building_push_force = Vector3.ZERO
	var space = player.get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.transform = player.transform
	query.collision_mask = 128
	query.shape = building_push_shape
	var result = space.collide_shape(query,5)
	for contact in result:
		var dist = contact.distance_to(player.global_position)
		var inverted_dist = building_push_radius - dist
		inverted_dist = clamp(inverted_dist,0.0,building_push_radius)
		building_push_force = contact.direction_to(player.global_position) * inverted_dist
	player.building_push_label.text = "Building Push: "+ str((building_push_force*building_push_force_strength).length() as int)
	return building_push_force * building_push_force_strength * building_push_force_mult

func _get_spring_force(target_dist,target_dir,hand)->Vector3:
	var spring_force = Vector3.ZERO
	if target_dist < rest_lengths[hand]:return spring_force
	var displacement = active_grappling_targets[hand].get_world_pos_with_offset() - player.global_position
	if target_dist>rest_lengths[hand]:
		spring_force += SpringUtil.hookes_law(displacement,player.velocity,cur_stiffness,damping)
	player.spring_label.text = "Spring: "+ str(spring_force.length() as int)
	return spring_force

func _get_floor_jumpforce(target_dist)->Vector3:
	var force = Vector3.ZERO
	if player.is_on_floor():
		var adjusted_distance = max(1.0,target_dist)
		var floor_bounce_strength = (1000.0)/max(player.velocity.length(),1.0)
		floor_bounce_strength = clamp(floor_bounce_strength,0,1000)
		force.y += floor_bounce_strength
	#player.floor_push_label.text = str(force.length() as int)
	return force

func _get_floor_push_force()->Vector3:
	var floor_push_force = Vector3.ZERO
	var space = player.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.global_position,player.global_position+Vector3.DOWN*floor_push_force_max_length,1)
	var result = space.intersect_ray(query)
	if result:
		#print(result.collider.name)
		var vert_dist = player.global_position.y - result.position.y
		var inverted_dist = floor_push_force_max_length - vert_dist
		floor_push_force += player.global_basis.y * inverted_dist * floor_push_force_strength * player.velocity.length()
	#print(floor_push_force)
	player.floor_push_label.text = "Floor Push: "+ str(floor_push_force.length() as int)
	return floor_push_force

func has_target()->bool:
	if grappling_shape_cast.is_colliding():
		var candidate = grappling_shape_cast.get_collider(0) as Node3D
		var candidate_is_grapple_target = Util.get_child_of_type(candidate,GrapplingTarget)
		var is_at_least_min_distance = grappling_shape_cast.get_collision_point(0).distance_to(player.global_position) > 0.2
		var is_relevant = candidate_is_grapple_target and is_at_least_min_distance
		var normal = grappling_shape_cast.get_collision_normal(0)
		var normal_up_dot = normal.dot(Vector3.UP)
		var is_not_floor = normal_up_dot < 0.9
		var is_above_player = player.global_position.y < grappling_shape_cast.get_collision_point(0).y
		return is_relevant and is_not_floor
	else: return false

#func _check_player_behind_target():
	#var target = active_grappling_target.get_world_pos_with_offset()
	#var player_dir_to_target = player.global_position.direction_to(target)
	#var player_look_dir_to_target = player_dir_to_target.dot(-player.head.global_basis.z)
	#var dot_product = player_dir_to_target.dot(normal)
	#if player_look_dir_to_target < -0.75:
		#retreat()

func _set_sky_ball_visibility(is_visible:bool):
	if is_visible: sky_ball.visible = true
	if sky_ball_scale_tween and sky_ball_scale_tween.is_running(): sky_ball_scale_tween.stop()
	sky_ball_scale_tween = get_tree().create_tween()
	var goal_scale = 1 if is_visible else 0
	sky_ball_scale_tween.tween_property(sky_ball,"scale",Vector3.ONE * goal_scale,1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if not is_visible: sky_ball.visible = false

func get_fraction(hand:Arms.Hand)->float:
	var target = active_grappling_targets[hand].get_world_pos_with_offset()
	var dist = player.global_position.distance_to(target)
	var fraction = active_grapple_durations[hand] /(launch_duration)
	var clamped_fraction = clampf(fraction,0.0,1.0)
	return clamped_fraction

func _set_relevant_cross_hair():
	var relevant_cross_hair = (HUD.CROSS_HAIR_TYPE.GRAPPLING if is_active_arr.size()==2
	 else HUD.CROSS_HAIR_TYPE.TARGET if has_target()
	 else HUD.CROSS_HAIR_TYPE.BASE)
	player.hud.set_cross_hair(relevant_cross_hair)

func shorten(delta):
	cur_stiffness = stiffness + stiffness_push_amount
	building_push_force_mult = 0.2
	for hand in Arms.Hand.values():
		if rest_lengths.has(hand):
			rest_lengths[hand] -= shortening_speed * delta
			rest_lengths[hand] = clamp(rest_lengths[hand],2.0,100.0)

func shorten_to_height(hand:Arms.Hand,original_hit_target_height:float):
	if rope_length_tweens.has(hand) and rope_length_tweens[hand].is_running(): rope_length_tweens[hand].stop()
	rope_length_tweens[hand] = get_tree().create_tween()
	rope_length_tweens[hand].tween_method(func(x):rest_lengths[hand] = x,rest_lengths[hand],original_hit_target_height,0.6)

func _get_distance_from_hit_to_ground(point:Vector3)->float:
	var space_state = player.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(point,point-Vector3(0,-100,0),1)
	var result = space_state.intersect_ray(query)
	var height = point.y
	if result:
		height = result.position.y-player.global_position.y
	return height

func _play_sound(is_launch):
	var relevant_sound = launch_sfx if is_launch else retreat_sfx
	audio_stream_player_3d.stream = relevant_sound
	audio_stream_player_3d.play()

func _decay_stiffness(delta):
	if cur_stiffness > stiffness:
		cur_stiffness -= cur_stiffness * stiffness_decay * delta
	if building_push_force_mult < 1.0:
		building_push_force_mult += building_push_force_mult * stiffness_decay * delta
