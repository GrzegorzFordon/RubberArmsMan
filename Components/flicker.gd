class_name Flicker
extends Node

signal value_updated(new_val:float)

@export var noise_texture:NoiseTexture2D
@export var csg_sphere_3d_2: CSGSphere3D
@export var light_3d: Light3D
@export var is_active := true
@export_range(0,5,0.1) var min_val:float
@export_range(0,5,0.1) var max_val:float
@export var speed:float

var active_index : float
var base_col:Color

func _ready() -> void:
	noise_texture.noise.seed = randi_range(0,100)
	base_col = csg_sphere_3d_2.material.albedo_color

func _process(delta: float) -> void:
	active_index += speed * delta
	var val = noise_texture.noise.get_noise_2d(active_index,0)
	val = remap(val,-1,1,0,1)
	#val = max(val,0.0)
	light_3d.light_energy = lerp(min_val,max_val,val)
	csg_sphere_3d_2.material.albedo_color = base_col * val
