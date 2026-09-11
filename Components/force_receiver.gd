class_name ForceReceiver
extends Node

signal force_received()

@export var auto_apply:=false
@export var force_decay_factor:=5.0

#Explosion
@export var explosion_mult:=2.0
@export var explosion_upwards_force_strength:=200
@export var explosion_travel_speed:=50

#Hit
@export var hit_mult:=2.0
@export var hit_upwards_force_strength:=10

var body : PhysicsBody3D
var hurt_box: HurtBox
var current_force:Vector3
var active_hit_data : HitData
var active_explosion_data : ExplosionData

func _ready() -> void:
	body = owner
	hurt_box = Util.get_child_of_type(body,HurtBox)
	#hurt_box.explosion_received.connect(_on_receive_explosion)
	hurt_box.hit_received.connect(_on_receive_hit)

func _physics_process(delta: float) -> void:
	if current_force == Vector3.ZERO: return
	if auto_apply: _apply_force(delta)
	_decay_force(delta)

func _on_receive_explosion(explosion_data:ExplosionData):
	active_explosion_data = explosion_data
	var direction = explosion_data.position.direction_to(body.global_position)
	var distance = body.global_position.distance_to(explosion_data.position)
	var intensity = explosion_data.intensity
	var distance_factor = max(0.0,explosion_data.radius-distance)
	await get_tree().create_timer(distance/explosion_travel_speed).timeout
	var force = direction * intensity * distance_factor * explosion_mult
	force.y += explosion_upwards_force_strength
	current_force += force
	force_received.emit()

func _on_receive_hit(hit_data:HitData):
	active_hit_data = hit_data
	var direction = hit_data.origin.direction_to(body.global_position)
	var hit_force = direction * hit_mult
	#hit_force.y += hit_upwards_force_strength
	current_force += hit_force
	force_received.emit(current_force)

func _decay_force(delta:float):
	if current_force == Vector3.ZERO: return
	current_force -= current_force * force_decay_factor * delta
	if current_force.length() < 1.0:
		current_force = Vector3.ZERO

func _apply_force(delta:float):
	if body is CharacterBody3D:
		body.velocity = current_force * delta
	if body is RigidBody3D:
		body.apply_force(current_force)
