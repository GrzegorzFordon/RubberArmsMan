@tool
class_name GridLayout
extends Node3D

@export var row_count := 5:
	set(new_count):
		row_count = new_count
		_set_children_grid()

@export var spacing := 20.0
@export var add_labels:=true

func _set_children_grid():
	for i in get_child_count():
		var child = get_child(i)
		if child is Node3D or MeshInstance3D:
			var x = i % row_count
			var z = i / row_count
			child.position = Vector3(x,0,z)*spacing
			if add_labels:
				var label3d = Label3D.new()
				label3d.text = child.name
				add_child(label3d)
				label3d.position = child.position + Vector3.UP * 1.5
				label3d.billboard = true
				label3d.owner = get_tree().edited_scene_root
				label3d.no_depth_test = true
				label3d.pixel_size = 0.03

func _reset_labels():
	for i in get_child_count():
		var child = get_child(get_child_count()-i-1)
		#print(child is Label3D,child)
		if child is Label3D:
			remove_child(child)
			child.queue_free()
