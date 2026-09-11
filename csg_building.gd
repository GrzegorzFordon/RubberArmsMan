extends Node3D

@export var window: Node3D
@export var window_2: Node3D
@export var color_arr:Array[Color]

@export var csg_box_big: CSGBox3D
@export var csg_box_small: CSGBox3D

func _ready() -> void:
	var is_big = randf()>0.2
	var relevant_box = csg_box_big if randf()>0.3 else csg_box_small
	scale = Vector3.ONE * randf_range(1.3,1.5)
	csg_box_big.visible = is_big
	csg_box_big.use_collision = is_big
	csg_box_big.process_mode = Node.PROCESS_MODE_INHERIT if is_big else Node.PROCESS_MODE_DISABLED
	csg_box_small.visible = !is_big
	csg_box_small.use_collision = !is_big
	csg_box_small.process_mode = Node.PROCESS_MODE_INHERIT if !is_big else Node.PROCESS_MODE_DISABLED
	relevant_box.material.set("shader_parameter/ColorParameter",color_arr.pick_random())
