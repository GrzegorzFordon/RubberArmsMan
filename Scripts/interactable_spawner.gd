extends Node3D

@export var interactable_item: PackedScene

func _ready() -> void:
	_spawn()

func _spawn():
	var new_item = interactable_item.instantiate() as InteractItem
	add_child(new_item)
	new_item.position = Vector3.ZERO
	new_item.item_lost.connect(_spawn)
