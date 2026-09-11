class_name Util
extends Node

static func get_child_of_type(parent:Node,type:Variant):
	if not parent: return null
	var children = parent.get_children()
	for child in children:
		if is_instance_of(child,type):
			return child
	return null

static func decay(value,amount,delta):
	var decayed_value = value - (value*amount*delta)
	var clamped_value = max(decayed_value,0.0)
	return clamped_value
