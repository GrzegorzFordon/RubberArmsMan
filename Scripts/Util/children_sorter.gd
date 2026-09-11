@tool
class_name ChildrenSorter
extends Node

@export var do_sort:=false:
	set(val):
		sort()

func sort():
	var sorted_children = get_children()
	sorted_children.sort_custom(_sort_name)
	for i in sorted_children.size():
		move_child(sorted_children[i],i)

func _sort_name(a:Node,b:Node)->bool:
	return a.name > b.name
