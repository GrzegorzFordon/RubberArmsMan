class_name Carryable
extends Node

@export var body: PhysicsBody3D
var interactable: Interactable
var active_interactor:Interactor
var cached_body_collision_layer:int
var cached_body_scale:Vector3
@export var spring_stiffness:=10.0
@export var spring_damping:=10.0

@export var shrink_factor := 2.0

func _ready() -> void:
	if not body and owner is PhysicsBody3D: body = owner
	interactable = Util.get_child_of_type(get_parent(),Interactable)
	if interactable:
		interactable.interact_started.connect(_set_interactor)
		interactable.interact_ended.connect(_reset_interactor)

func _set_interactor(_interactor:Interactor):
	cached_body_collision_layer = body.collision_layer
	body.set_collision_layer_value(1,false)
	if body is RigidBody3D: body.gravity_scale = 0
	active_interactor = _interactor
	cached_body_scale = body.scale
	body.scale /= shrink_factor  

func _reset_interactor(_interactor:Interactor):
	body.set_collision_layer_value(1,true)
	if body is RigidBody3D: body.gravity_scale = 1
	active_interactor = null
	body.scale = cached_body_scale

func _physics_process(delta: float) -> void:
	if active_interactor: _update_carry(delta)

func _update_carry(delta):
	if not active_interactor: return
	#var pos_offset_to_interactor =  active_interactor.player.hand_marker_left.global_position-body.global_position
	body.position = lerp(body.position,Vector3.ZERO,10.0*delta)
	return
	#if body is RigidBody3D:
		#var force = SpringUtil.hookes_law(pos_offset_to_interactor,body.linear_velocity,spring_stiffness,spring_damping)
		#body.linear_velocity = force
	#if body is CharacterBody3D:
		#var force = SpringUtil.hookes_law(pos_offset_to_interactor,body.velocity,spring_stiffness,spring_damping)
		#body.velocity += force * delta

#func _shoot_as_projectile(_interactor):
	#var throw_direction = _interactor.hand_marker.global_basis.z.normalized()
	#var impulse_vector = throw_direction * 300 / min(body.mass,50.0)
	#body.apply_impulse(impulse_vector,body.global_position)
	#body.linear_velocity = impulse_vector
