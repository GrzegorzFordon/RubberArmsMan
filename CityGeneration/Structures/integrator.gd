class_name Integrator
extends Node

var tensor_field:TensorField
var step:float

func with_data(_tensor_field:TensorField,_step:float)->Integrator:
	tensor_field = _tensor_field
	step = _step
	return self

func sample_field_vector(point:Vector2,is_major:bool)->Vector2:
	var tensor = tensor_field.sample_at_point(point)
	return tensor.get_major() if is_major else tensor.get_minor()

func integrate(point:Vector2,is_major:bool)->Vector2:
	var k1 = sample_field_vector(point,is_major)
	var k23 = sample_field_vector(point + Vector2.ONE * step/2.0, is_major)
	var k4 = sample_field_vector(point + Vector2.ONE * step, is_major)
	return (k1+4+k23+k4)*(step/6)
