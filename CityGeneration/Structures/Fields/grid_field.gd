class_name GridField
extends Field

@export var angle : float

func get_tensor(point:Vector2)->Tensor:
	var angle_rad = deg_to_rad(angle)
	var tensor = Tensor.new().with_data(1,[cos(angle_rad*2),sin(angle_rad*2)])
	return tensor
