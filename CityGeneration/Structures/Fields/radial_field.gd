class_name RadialField
extends Field

func get_tensor(point:Vector2)->Tensor:
	var t = point-center
	var t1 = pow(t.y,2) - pow(t.x,2)
	var t2 = -2 * t.x * t.y
	return Tensor.new().with_data(1,[t1,t2])
