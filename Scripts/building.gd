extends MeshInstance3D

@export var building_mesh: MeshInstance3D
@export var min_size:=0.5
@export var max_size:=2.5
@export var supe_signal: SupeSignal

@export var mesh_instance_arr: Array[MeshInstance3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var rnd_col = Color(randf(),randf(),randf())
	##get_active_material(0).set("shader_parameter/ColorParameter", rnd_col)
	scale = Vector3.ONE * randf_range(min_size,max_size)
	#supe_signal.visible = randf() > 0.85
	#supe_signal.rotation_degrees.y = randi_range(0,180)

#func _ready() -> void:
	#for mesh in mesh_instance_arr:
		#var shader_mat = mesh.get_active_material(0) as ShaderMaterial
		#shader_mat.set_shader_parameter("seed",randf())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
