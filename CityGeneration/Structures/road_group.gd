class_name RoadGroup
extends Node

var integrator : Integrator
var world_size : Vector2
var streamline_params : StreamlineParams
var existing_streamlines : Array[RoadGroup]

var streamlines:Streamlines

@export var draw_color : Color

func with_data(_integrator:Integrator,_world_size:Vector2,_streamline_params:StreamlineParams):
	integrator = _integrator
	world_size = _world_size
	streamline_params = _streamline_params
	return self

func generate():
	streamlines = Streamlines.new().with_data(integrator,world_size,streamline_params)
	#add existing
	for road_group in existing_streamlines:
		if road_group.streamlines:
			streamlines.add_existing_streamlines(road_group.streamlines)
	#create all
	streamlines.create_all_streamlines()
	pass

func draw():
	if not streamlines: return
	#Draw line for each sample
	pass
