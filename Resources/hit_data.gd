class_name HitData
extends Resource

var origin : Vector3
var power : float

func with_data(_origin:Vector3,_power:float):
	origin = _origin
	power = _power
	return self
