class_name HomingMissile
extends CharacterBody3D

@export var target:CharacterBody3D
@export var debug_target_mesh: MeshInstance3D


@export var speed:=10.0
@export var max_speed:=10.0
@export var rotation_speed:=10.0
@export var min_dist_predict:=5.0
@export var max_dist_predict:=100.0
@export var max_predict_time:=5.0

@export var deviation_amount:=50.0
@export var deviation_speed:=2.0
@export var sprite_3d: Sprite3D
@export var dist_label: Label3D
@export var gradient:Gradient
@export var mesh_instance_3d: MeshInstance3D
@export var text_mesh: MeshInstance3D
@export var danger_indicator: DangerIndicator
var predicted_target:Vector3
var deviated_predicted_target:Vector3

var time_since_spawn:=0.0

@export var noise_sampler: NoiseSampler


func _physics_process(delta: float) -> void:
	time_since_spawn += delta
	velocity -= velocity * 5.0 * delta
	velocity += -global_basis.z * speed * delta
	velocity = velocity.limit_length(max_speed)
	move_and_slide()
	var distance = global_position.distance_to(target.global_position)
	var lead_time_percentage = remap(distance,min_dist_predict,max_dist_predict,0,1)
	lead_time_percentage = clamp(lead_time_percentage,0.0,1.0)
	_predict(lead_time_percentage)
	_deviate(lead_time_percentage)
	_rotate_rocket(delta)
	_set_cross_hair_color()

func _update(delta):
	#velocity += _seek() * delta
	#var look_at_transform = transform.looking_at(target.global_position+Vector3.UP)
	#transform = transform.interpolate_with(look_at_transform,5.0*delta)
	velocity += -global_basis.z * speed * delta

func _predict(lead_time_percentage:float):
	var prediction_time = lerpf(0.0,max_predict_time,lead_time_percentage)
	predicted_target = target.global_position + target.velocity * prediction_time

func _deviate(lead_time_percentage:float):
	var deviation = cos(time_since_spawn * deviation_speed * PI)
	var deviation_x = noise_sampler.sample(Vector2(0,time_since_spawn * deviation_speed))
	var deviation_y = noise_sampler.sample(Vector2(time_since_spawn * deviation_speed,0))
	var deviation_vector = -basis.z * Vector3(deviation,0,0) * deviation_amount * lead_time_percentage
	deviated_predicted_target = predicted_target + deviation_vector

func _rotate_rocket(delta):
	var rotation = global_transform.looking_at(deviated_predicted_target)
	global_transform = global_transform.interpolate_with(rotation,rotation_speed*delta)

func _set_cross_hair_color():
	var distance = global_position.distance_to(target.global_position)
	var sample_val = remap(distance,50.0,300.0,0.0,1.0)
	sample_val = clamp(sample_val,0.0,1.0)
	var color = gradient.sample(sample_val)
	text_mesh.mesh.text = str(global_position.distance_to(target.global_position) as int)
	mesh_instance_3d.get_active_material(0).set("albedo_color",color)
	text_mesh.get_active_material(0).set("albedo_color",color)
	danger_indicator.set_color(color)
	danger_indicator.set_distance(global_position.distance_to(target.global_position) as int)
