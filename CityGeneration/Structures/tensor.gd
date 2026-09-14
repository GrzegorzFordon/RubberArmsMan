class_name Tensor
extends Node

var r
var m = []

var theta:float
var old_th := false

func with_data(_r,_m):
	r = _r
	m = _m 
	_calc_theta()
	return self

func add(tensor:Tensor,smooth:bool):
	for i in m.size():
		m[i] = m[i] * r + tensor.m[i] * tensor.r
	
	if smooth:
		r = sqrt(pow(m[0],2)+pow(m[1],2))
		m = m.map(func(v):return v/r)
	else:
		r = 2
	old_th = true

func get_major():
	if r == 0: return Vector2.ZERO
	var theta = get_theta()
	return Vector2(cos(theta),sin(theta))

func get_minor():
	if r == 0: return Vector2.ZERO
	var angle = get_theta() + PI/2
	return Vector2(cos(angle),sin(angle))

func get_theta():
	if old_th: _calc_theta()
	old_th = false
	return theta

func _calc_theta():
	if r == 0: 
		theta = 0.0
	else:
		theta = atan2(m[1]/r,m[0]/r)/2

static func zero()->Tensor:
	var zero_tensor = Tensor.new().with_data(1,[0,0])
	return zero_tensor
