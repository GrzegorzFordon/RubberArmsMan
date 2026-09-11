class_name Spawner
extends Node3D

@export var scene:PackedScene
@export var amount:=100
#@export var area:Vector3
@export var spawns_arr:Array[Marker3D]
@export var timer: Timer

func _ready() -> void:
	timer.timeout.connect(_spawn_car)

func _spawn_car():
	if not spawns_arr:return
	var scene_instance = scene.instantiate() as Node3D
	add_child(scene_instance)
	scene_instance.global_position = spawns_arr.pick_random().global_position
	timer.wait_time = randf_range(0.5,1.0)
	#var rnd_pos_mult_vector = Vector3(randf()*2-1,0,randf()*2-1)
	#scene_instance.global_position = area * rnd_pos_mult_vector
