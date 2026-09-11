class_name VisionCone
extends Node3D

@export var target_type:Node

@export var objects_within_area:Array[Node3D]
@export var currently_seen_objects:Array[Node3D]




var target : Node3D
@export var update_timer: Timer

func _ready() -> void:
	update_timer.timeout.connect(_check_vision)

func _check_vision():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		var angle_to_target = global_position.dot(target.global_position)
		#print(angle_to_target)
		#print("see you")
	#else:
		#print("lost you")
	#pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		objects_within_area.append(body)
		target = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		objects_within_area.erase(body)
		target = null
