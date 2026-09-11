class_name ExplosionData
extends Resource

var position:Vector3
var intensity:float
var radius:float
#var source:Combat

func with_data(_position:Vector3,_intensity:float,_radius:float):
	position = _position
	intensity = _intensity
	radius = _radius
	return self
