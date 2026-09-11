extends Node3D

@export var mesh_instance_letter: MeshInstance3D
@export var mesh_instance_letter_outline: MeshInstance3D
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

func _ready() -> void:
	var letter_mesh = mesh_instance_letter.mesh as TextMesh
	var letter_mesh_outline = mesh_instance_letter_outline.mesh as TextMesh
	var letter = alphabet[randi_range(0,alphabet.length()-1)]
	letter_mesh.text = letter
	letter_mesh_outline.text = letter
