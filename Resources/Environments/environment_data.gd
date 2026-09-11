class_name EnvironmentData
extends Resource

@export_range(0.0,1.0,0.1) var skybox_weight: float
@export var fog_mode:Environment.FogMode
@export var fog_light_color:Color
@export var fog_density:float
@export_range(0.0,1.0,0.1) var fog_sun_scatter:float
@export_range(0.0,1.0,0.1) var fog_aerial_perspective:float
@export_range(0.0,1.0,0.1) var fog_sky_affect:float

@export_range(0.0,1.0,0.05) var vol_fog_density:float
@export var vol_fog_albedo:Color
@export var vol_fog_emission:Color
