class_name GridStorage
extends Node

var grid_dimensions : Vector2
var world_size : Vector2
var sep : float
var grid = []

func with_data(_world_size:Vector2,_sep:float)->GridStorage:
	world_size = _world_size
	sep = _sep
	grid_dimensions = world_size/sep
	for x in grid_dimensions.x:
		grid[x] = []
		for y in grid_dimensions.y:
			grid[x][y] = []
	return self

func add_polyline(line:Array[Vector2]):
	for point in line: add_sample(point)

func add_all(grid_storage:GridStorage):
	for row in grid_storage.grid:
		for cell in row:
			for sample in cell:
				add_sample(sample)

func add_sample(point:Vector2):
	var coords = get_sample_coords(point)
	add_sample_with_coords(point,coords)

func add_sample_with_coords(point:Vector2,coords:Vector2):
	grid[coords.x as int][coords.y as int].appent(point)

func get_nearby_points(point:Vector2,distance:float):
	var radius = ceil(distance/sep-0.5) as int
	var coords = get_sample_coords(point)
	var out_vectors : Array[Vector2]
	for i in range(-radius,radius):
		for j in range(-radius,radius):
			var cell = coords + Vector2(i,j)
			if not _is_vector_out_of_bounds(cell,grid_dimensions):
				for point_vector in grid[cell.x as int][cell.y as int]:
					out_vectors.append(point_vector)
	return out_vectors

func get_sample_coords(world_point:Vector2)->Vector2:
	if _is_vector_out_of_bounds(world_point,world_size): return Vector2.ZERO
	return Vector2(floor(world_point.x/sep),floor(world_point.y/sep))

func _is_vector_out_of_bounds(grid_point:Vector2,bounds:Vector2):
	var less_than_zero = grid_point.x < 0 or grid_point.y < 0
	var bigger_than_bounds = grid_point.x >= bounds.x or grid_point.y >= bounds.y
	return less_than_zero or bigger_than_bounds

func _is_valid_sample(point:Vector2,square_distance:float):
	var coords = get_sample_coords(point)
	for i in range(-1,1):
		for j in range(-1,1):
			var cell = coords + Vector2(i,j)
			if not _is_vector_out_of_bounds(point,grid_dimensions):
				if not _is_point_far_from_points(point,grid[cell.x as int][cell.y as int],square_distance):
					return false
	return true

func _is_point_far_from_points(point:Vector2,points:Array[Vector2],square_distance:float)->bool:
	for sample in points:
		if not sample.is_equal_approx(point):
			var sqD = sample.distance_squared_to(point)
			if square_distance < sqD: return false
	return true
