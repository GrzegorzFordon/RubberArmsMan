extends Node3D

@export var target:Node3D
@export var label_3d: Label3D

func _ready() -> void:
	if not target:
		var player = Util.get_child_of_type(get_tree().root,Player)
		if player: target = player

func _process(delta: float) -> void:
	if not target:return
	var dist = global_position.distance_to(target.global_position)
	label_3d.text = str(dist as int)+"m"
