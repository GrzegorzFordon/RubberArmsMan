class_name Streamlines
extends Node

var all_streamlines = []
var all_streamlines_simple = []
var major_streamlines = []
var minor_streamlines = []

var integrator : Integrator
var params : StreamlineParams
var world_size : Vector2

var major : GridStorage
var minor : GridStorage

var params_squared : StreamlineParams

func with_data(_integrator:Integrator,_world_size:Vector2,_params:StreamlineParams)->Streamlines:
	integrator = _integrator
	params = _params
	world_size = _world_size
	major = GridStorage.new().with_data(world_size,params.sep)
	minor = GridStorage.new().with_data(world_size,params.sep)
	set_params_squared(params)
	return self

func get_best_next_spot(point:Vector2,prev_point:Vector2):
	var nearby_points = major.get_nearby_points(point,params.lookahead)
	nearby_points.append_array(minor.get_nearby_points(point,params.lookahead))
	var direction = point - prev_point
	var closest_sample = null
	var closest_distance = INF
	for sample in nearby_points:
		if sample != point and sample != prev_point:
			var diff_vec = sample - point
			var dot_diff_vec = diff_vec.dot(direction)
			if dot_diff_vec < 0: continue
			var dist_to_sample = point.distance_squared_to(sample)
			if dist_to_sample < closest_distance and dist_to_sample < 2 * 0.01 * 0.01:
				closest_distance = dist_to_sample
				closest_sample = sample
				continue
			var angle_between = abs(direction.angle_to(diff_vec))
			if(angle_between<params.joinAngle and dist_to_sample < closest_distance):
				closest_distance = dist_to_sample
				closest_sample = sample
	if closest_sample: closest_sample += direction.normalized() * params.simplifyTolerance * 4
	return closest_sample

func set_params_squared(params:StreamlineParams):
	params_squared = StreamlineParams.new()
	params_squared.sep = params.sep * params.sep
	params_squared.test = params.test * params.test
	params_squared.step = params.step * params.step
	params_squared.lookahead = params.lookahead * params.lookahead
	params_squared.circleJoin = params.circleJoin * params.circleJoin
	params_squared.joinAngle = params.joinAngle * params.joinAngle
	params_squared.pathIterations = params.pathIterations * params.pathIterations
	params_squared.seedTries = params.seedTries * params.seedTries
	params_squared.simplifyTolerance = params.simplifyTolerance * params.simplifyTolerance
	params_squared.colliderEarly = params.colliderEarly * params.colliderEarly

func add_existing_streamlines(streamlines:Streamlines):
	major.add_all(streamlines.major)
	minor.add_all(streamlines.minor)

func create_all_streamlines():
	var is_major = true
	while(create_streamline(is_major)): is_major = !is_major
	join_dangling_streamlines()

func create_streamline(is_major:bool)->bool:
	var seed = _get_seed(is_major)
	var is_valid = false
	if seed:
		var streamline = _integrate_streamline(seed,is_major)
		if _is_valid_streamline(streamline):
			pass
	return is_valid

func join_dangling_streamlines():
	pass

func _get_seed(is_major:bool):
	var seed = _sample_point()
	var i = 0
	while not _is_valid_sample(is_major,seed,params_squared.sep):
		if i >= params.seedTries: return null
		seed = _sample_point()
		i += 1
	return seed

func _sample_point()->Vector2:
	return Vector2(randf()*world_size.x,randf()*world_size.y)

func _is_valid_sample(is_major:bool,point:Vector2,d_squared:float,both_grids:bool=false)->bool:
	return true

func _integrate_streamline(seed:Vector2,is_major:bool):
	var count = 0
	var points_escaped = false
	var collide_both = randf()<params.colliderEarly
	var d = integrator.integrate(seed,is_major)
	var forward_integration_params = StreamlineIntegration.new().with_data(seed,d,[],d,seed+d,true)
	forward_integration_params.is_valid = _point_in_bounds(forward_integration_params.prev_point)
	var backwards_integration_params = StreamlineIntegration.new().with_data(seed,-d,[],-d,seed-d,true)
	backwards_integration_params.is_valid = _point_in_bounds(backwards_integration_params.prev_point)
	var finished = false
	while not finished and count < params.pathIterations and (forward_integration_params.is_valid or backwards_integration_params.is_valid):
		_streamline_integration_step(forward_integration_params,is_major,collide_both)
		_streamline_integration_step(backwards_integration_params,is_major,collide_both)
		
		var square_distance_between_points = forward_integration_params.prev_point.distance_squared_to(backwards_integration_params.prev_point)
		if not points_escaped and square_distance_between_points > params.circleJoin: points_escaped = true
		if points_escaped and square_distance_between_points <= params.circleJoin:
			forward_integration_params.streamline.append(forward_integration_params.prev_point)
			forward_integration_params.streamline.append(backwards_integration_params.prev_point)
			backwards_integration_params.streamline.append(backwards_integration_params.prev_point)
			finished = true
		count += 1
		backwards_integration_params.streamline.reverse()
		backwards_integration_params.streamline.append_array(forward_integration_params.streamline)
		#var s_line = backwards_integration_params.streamline
		#forward_integration_params.queue_free()
		#backwards_integration_params.queue_free()
		return backwards_integration_params.streamline

func _streamline_integration_step(params:StreamlineIntegration,is_major:bool,collide_both:bool):
	pass

func _point_in_bounds(point:Vector2)->bool:
	var is_bigger_than_zero = point.x > 0 and point.y > 0
	var is_smaller_than_world_size = point.x < world_size.x and point.y < world_size.y
	return is_bigger_than_zero and is_smaller_than_world_size

func _is_valid_streamline(streamline:Array[Vector2])->bool:
	return streamline.size() > 5

func _get_points_between(point_a:Vector2,point_b:Vector2,step:float):
	var d = point_a.distance_to(point_b)
	var n_points = floor(d/step)
	if n_points == 0: return []
	var step_vec = point_b - point_a
	var out_vectors : Array[Vector2]
	var next = point_a + step_vec * (1/n_points)
	for i in range(1,n_points+1):
		if integrator.integrate(next,true).length_squared() > 0.001:
			out_vectors.append(next)
		else:
			return out_vectors
		next = point_a + step_vec * (i/n_points)
	return out_vectors
