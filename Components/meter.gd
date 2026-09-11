class_name Meter
extends Node

signal value_changed(new_value:int)
signal value_emptied()

@export var use_all_if_not_enough:=true
@export var auto_refill:=true
@export var auto_refill_speed:=1.0
@export var auto_refill_delay_duration:=0.2
var max_value:=100.0
var cur_value:float

var time_since_last_use:=0.0

func _ready() -> void:
	await owner.ready
	_reset()

func _physics_process(delta: float) -> void:
	time_since_last_use += delta
	if auto_refill and time_since_last_use >= auto_refill_delay_duration:
		_refill(delta)

func try_use(amount:float)->bool:
	time_since_last_use = 0.0
	var has_enough = cur_value >= amount
	if has_enough or use_all_if_not_enough:
		cur_value -= amount
		cur_value = max(cur_value,0)
		value_changed.emit(cur_value)
		if cur_value == 0.0: value_emptied.emit()
	return has_enough

func _reset():
	cur_value = max_value
	value_changed.emit(cur_value)

func _refill(delta):
	cur_value += auto_refill_speed * delta * max_value
	cur_value = min(cur_value,max_value)
	value_changed.emit(cur_value)

func is_empty()->bool:
	return cur_value==0.0
