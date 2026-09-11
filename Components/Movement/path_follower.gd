class_name PathFollower
extends PathFollow3D

signal finished()

@export var speed:=1.0
@export_range(0.0,1.0) var start_offset:=1.0
@export var repeat:=true
@export var enable_look_at:=true
@export var model: Node3D

var path:Path3D
var direction:=0
var last_pos=Vector3.ZERO

func _ready() -> void:
	start_offset = randf()
	direction = 1 if start_offset < 0.5 else -1
	progress_ratio += start_offset
	last_pos = global_position
	use_model_front =start_offset < 0.5

func _process(delta: float) -> void:
	if not path: path = get_parent() as Path3D
	var length = path.curve.get_baked_length()
	progress_ratio += speed * delta / length * direction
	progress_ratio = fmod(progress_ratio,1.0)
	var dir = last_pos-global_position
	#model.look_at(Vector3(dir.x,global_position.y,dir.z))
	last_pos = global_position
	if (progress_ratio == 1 or progress_ratio == 0) and not repeat:
		finished.emit()
		queue_free()
