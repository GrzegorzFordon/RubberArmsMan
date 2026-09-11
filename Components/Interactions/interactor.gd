class_name Interactor
extends Node

@export var player: Player
@export var hand_marker: Marker3D
@export var shape_cast_3d: ShapeCast3D

@export var hold_strength:=5.0
@export var throw_strength:=5.0
@export var max_distance:=50.0

var active_interactable:Interactable
var current_candidate:Interactable
var is_interacting := false

func start_interact():
	if not current_candidate:return
	active_interactable = current_candidate
	active_interactable.start_interact(self)

func stop_interact():
	if not active_interactable:return
	active_interactable.stop_interact(self)
	active_interactable = null

func _process(delta: float) -> void:
	_check_candidates()
	player.hud.set_interaction_cross_hair(current_candidate and not active_interactable)

func _check_candidates():
	var potential_interactable : Interactable
	if shape_cast_3d.is_colliding():
		var collider = shape_cast_3d.get_collider(0) as Node
		if collider is Node3D:
			potential_interactable = Util.get_child_of_type(collider,Interactable)
	if potential_interactable:
		if potential_interactable != current_candidate:
			potential_interactable.start_look_at(self)
	elif current_candidate:
		current_candidate.end_look_at(self)
	current_candidate = potential_interactable

func has_candidate():
	return current_candidate != null
