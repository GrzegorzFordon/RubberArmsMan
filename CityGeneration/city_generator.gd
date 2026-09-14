class_name CityGenerator
extends Control

@export var world_size : Vector2

@export var tensor_field: TensorField
@export var timer: Timer

enum ROAD_TYPE {MAIN,MAJOR,MINOR}

var road_group_dict : Dictionary[ROAD_TYPE,RoadGroup]

#var main_road_group : RoadGroup
#var major_road_group : RoadGroup
#var minor_road_group : RoadGroup

@export var scalar:float
@export var default_streamline_params: StreamlineParams

#Draw

@export var draw_tensor:=true
@export var draw_roads:=true

@export var tensor_line_width:=1.0
@export var show_fields:=true

func _ready() -> void:
	tensor_field.set_points(world_size)
	var integrator = Integrator.new().with_data(tensor_field,1.0)
	road_group_dict[ROAD_TYPE.MAIN] = RoadGroup.new().with_data(integrator,world_size,default_streamline_params)
	road_group_dict[ROAD_TYPE.MAJOR] = RoadGroup.new().with_data(integrator,world_size,default_streamline_params)
	road_group_dict[ROAD_TYPE.MINOR] = RoadGroup.new().with_data(integrator,world_size,default_streamline_params)
	road_group_dict[ROAD_TYPE.MAJOR].streamline_params.sep = 5.0
	road_group_dict[ROAD_TYPE.MINOR].streamline_params.sep = 2.5
	road_group_dict[ROAD_TYPE.MAJOR].existing_streamlines = [road_group_dict[ROAD_TYPE.MAIN]]
	road_group_dict[ROAD_TYPE.MINOR].existing_streamlines = [road_group_dict[ROAD_TYPE.MAIN],road_group_dict[ROAD_TYPE.MAJOR]]
	
	timer.timeout.connect(func():queue_redraw())

func _draw() -> void:
	if draw_tensor:
		for point in tensor_field.points:
			var tensor = tensor_field.sample_at_point(point)
			var major_line = tensor_field.get_line_at_point(point,tensor.get_major())
			var minor_line = tensor_field.get_line_at_point(point,tensor.get_minor())
			draw_line(major_line[0]*scalar,major_line[1]*scalar,Color.BLACK,tensor_line_width)
			draw_line(minor_line[0]*scalar,minor_line[1]*scalar,Color.BLACK,tensor_line_width)
			tensor.queue_free()
		for field in tensor_field.fields:
			if not field.enabled or not show_fields: continue
			draw_circle(field.center*scalar,5.0,field.debug_color)
			draw_circle(field.center*scalar,field.size*scalar,field.debug_color,false)

#
#city generation
#1. create data structure
#2. generate city
#focus on 1 for now
#
#a. water - also includes island polygons? or/and water texture (binary)
#b. tensors
#c. main roads
#d. big roads
#e. small roads
#f. buildings & parks
