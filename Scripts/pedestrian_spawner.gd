class_name PedestrianSpawner
extends Node

const PEDESTRIAN = preload("uid://c642go7uhs2wf")

@export var active_paths : Array[Path3D]
@export var timer: Timer
@export var max_amount = 100

var active_pedestrians:Array[PathFollower]

func _ready() -> void:
	timer.timeout.connect(_spawn_pedestrian)

func _spawn_pedestrian():
	for path in active_paths:
		if active_pedestrians.size() > max_amount * active_paths.size():return
		var new_pedestrian = PEDESTRIAN.instantiate() as PathFollower
		new_pedestrian.h_offset = randf_range(-0.5,0.5)
		path.add_child(new_pedestrian)
		active_pedestrians.append(new_pedestrian)
		new_pedestrian.finished.connect(func():active_pedestrians.erase(new_pedestrian))
