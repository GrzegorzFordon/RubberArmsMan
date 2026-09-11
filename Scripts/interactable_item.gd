class_name InteractItem
extends RigidBody3D

signal item_lost()
@export var respawner: Respawner
@export var collision_shape_3d: CollisionShape3D
@export var mesh_instance_3d: MeshInstance3D
@export var interactable: Interactable
@export var outline_mesh: MeshInstance3D
@export var base_outline_color:Color
@export var looked_at_outline_color:Color


var outline_color_tween:Tween
var interaction_tween:Tween

@export var size := 0.5



func _ready() -> void:
	respawner.respawned.connect(func():item_lost.emit())
	interactable.look_at_started.connect(func(val):_on_look_at(true))
	interactable.look_at_ended.connect(func(val):_on_look_at(false))
	interactable.interact_started.connect(func(val):_on_interact(true))
	interactable.interact_ended.connect(func(val):_on_interact(false))

func _set_size(size):
	var shape = collision_shape_3d.shape as BoxShape3D
	var mesh = mesh_instance_3d.mesh as BoxMesh
	var outline_mesh = outline_mesh.mesh as BoxMesh
	shape.size = size*Vector3.ONE
	mesh.size = size*Vector3.ONE
	outline_mesh.size = size*Vector3.ONE

func _on_look_at(is_looked_at:bool):
	var material = outline_mesh.get_active_material(0)
	var relevant_color = looked_at_outline_color if is_looked_at else base_outline_color
	if outline_color_tween and outline_color_tween.is_running(): outline_color_tween.stop()
	outline_color_tween = get_tree().create_tween()
	outline_color_tween.tween_property(material,"albedo_color",relevant_color,0.1)
	outline_color_tween.play()

func _on_interact(is_active:bool):
	var alpha_val = 0.15 if is_active else 0.0
	outline_mesh.visible = not is_active
	if interaction_tween and interaction_tween.is_running(): interaction_tween.stop()
	interaction_tween = get_tree().create_tween()
	interaction_tween.tween_property(mesh_instance_3d,"transparency",alpha_val,0.1)
