class_name DayNight
extends Node

@export var base_environment: Environment
@export var sun_light: DirectionalLight3D
@export var timer: Timer

@export var day_environment_data: EnvironmentData
@export var night_environment_data: EnvironmentData

@export var transition_duration:=5.0
@export var sky_rotation_duration := 10.0

var is_day := true
var tween: Tween

func _ready() -> void:
	timer.timeout.connect(_switch)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"): _switch()

func _switch():
	is_day = !is_day
	print("Switching to: ","day" if is_day else "night")
	var relevant_data = day_environment_data if is_day else night_environment_data
	var sky_mat = base_environment.sky.sky_material as ShaderMaterial
	if tween and tween.is_running():tween.stop()
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property(sky_mat,"shader_parameter/weight",relevant_data.skybox_weight,transition_duration)
	tween.tween_property(base_environment,"fog_light_color",relevant_data.fog_light_color,transition_duration)
	tween.tween_property(base_environment,"fog_density",relevant_data.fog_density,transition_duration)
	tween.tween_property(base_environment,"fog_sun_scatter",relevant_data.fog_sun_scatter,transition_duration)
	tween.tween_property(base_environment,"fog_aerial_perspective",relevant_data.fog_aerial_perspective,transition_duration)
	tween.tween_property(base_environment,"fog_sky_affect",relevant_data.fog_sky_affect,transition_duration)
	tween.tween_property(base_environment,"volumetric_fog_density",relevant_data.vol_fog_density,transition_duration)
	tween.tween_property(base_environment,"volumetric_fog_albedo",relevant_data.vol_fog_albedo,transition_duration)
	tween.tween_property(base_environment,"volumetric_fog_emission",relevant_data.vol_fog_emission,transition_duration)
	tween.play()
	tween.finished.connect(func():print("done"))

func _rotate_sky_box(delta:float):
	base_environment.sky_rotation.z += fmod(TAU / sky_rotation_duration * delta,360.0)
	sun_light.global_rotation.x += fmod(TAU / sky_rotation_duration * delta,360.0)
