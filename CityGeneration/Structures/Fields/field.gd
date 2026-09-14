@abstract
class_name Field
extends Node

@export var enabled : bool

@export var center : Vector2
@export var size : float
@export var decay : float

@export var debug_color : Color

func get_weighted_tensor(point:Vector2,smooth:bool):
	var tensor = get_tensor(point)
	var weight = get_weight(point,smooth)
	tensor.r *= weight
	return tensor

func get_weight(point:Vector2,smooth:bool)->float:
	var dist = (point-center).length() / size
	if smooth: return pow(dist,-decay)
	if decay == 0 or dist >= 1: return 0
	var weight = pow(max(0,1-dist),decay)
	return weight

@abstract func get_tensor(point:Vector2)->Tensor
