class_name TensorField
extends Node

@export var smooth : bool
@export var water_texture:Texture2D
@export var diameter:float

var points : Array[Vector2]

var fields : Array[Field]

func _ready() -> void:
	fields = _get_fields()

func sample_at_point(point:Vector2):
	var new_tensor = Tensor.zero()
	for field in fields:
		if not field.enabled: continue
		var field_tensor = field.get_weighted_tensor(point,smooth)
		new_tensor.add(field_tensor,smooth)
		field_tensor.queue_free()
	return new_tensor

func get_line_at_point(point:Vector2,tensor:Vector2):
	var diff = tensor * diameter
	var start = point - diff
	var end = point + diff
	return [start,end]

func _get_fields()->Array[Field]:
	var arr : Array[Field]
	for child in get_children():
		if child is Field:
			arr.append(child as Field)
	return arr

func set_points(world_size:Vector2):
	points.clear()
	var n = Vector2(ceilf(world_size.x/diameter),world_size.y/diameter)
	for x in range(-n.x*0.5,(n.x+2)*0.5):
		for y in range(-n.y*0.5,(n.y+2)*0.5):
			points.append(Vector2(x,y))
