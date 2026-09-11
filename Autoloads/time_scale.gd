extends Node

const TWEEN_DURATION:=0.5
var is_slowed_down:=false
#var time_scale := 1.0
var tween

#func get_time_scale():
	#return time_scale

func slow_time(is_slowed:bool):
	if is_slowed_down == is_slowed: return
	is_slowed_down = is_slowed
	var new_time_scale = 0.05 if is_slowed else 1.0
	if tween: tween.stop()
	tween = get_tree().create_tween().set_ignore_time_scale()
	tween.tween_property(Engine,"time_scale",new_time_scale,TWEEN_DURATION).set_trans(Tween.TRANS_SINE)
	tween.play()
