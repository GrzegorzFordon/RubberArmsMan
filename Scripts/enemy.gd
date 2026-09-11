class_name Enemy
extends CharacterBody3D

@export var state_machine: StateMachine
@export var hurt_box: HurtBox
@export var movement: Movement
@export var health_meter: Meter
@export var health_bar: MeshInstance3D
@export var health_label: Label3D
@export var animation_tree_controller: AnimationTreeController
@export var force_receiver: ForceReceiver
@export var state_label: Label3D
@export var hit_receiver: HitReceiver
@export var hit_react_ik: HitReactIK
@export var weapon_ik: FABRIK3D
@export var weapon_parent: Node3D
@export var armor_bar: MeshInstance3D
@export var armor_meter: Meter
@export var bars: Node3D

@export var enable_gravity := true
@export var projectile: PackedScene
@export var projectile_speed:=50.0
@export var marker_3d_3: Marker3D
@export var timer: Timer

#State Flags
var is_dead:=false

func _ready() -> void:
	health_meter.value_changed.connect(_set_health_bar_shader)
	armor_meter.value_changed.connect(_set_armor_bar_shader)
	motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED if enable_gravity else CharacterBody3D.MOTION_MODE_FLOATING

func _process(delta: float) -> void:
	state_machine.tick(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_tick(delta)
	if enable_gravity: velocity -= Vector3.UP * delta * 44
	move_and_slide()

func _set_health_bar_shader(val:float):
	health_bar.set_instance_shader_parameter("health",val)
	health_label.text = str(val as int)

func _set_armor_bar_shader(val:float):
	armor_bar.set_instance_shader_parameter("health",val)
	armor_bar.visible = val != 0

func shoot_projectile():
	var new_projectile = projectile.instantiate() as Projectile
	get_tree().current_scene.add_child(new_projectile)
	new_projectile.global_position = marker_3d_3.global_position
	var forward = -marker_3d_3.global_basis.z
	var velocity = forward * projectile_speed
	new_projectile.look_at(new_projectile.global_position + forward)
	var hit_data = HitData.new().with_data(marker_3d_3.global_position,10)
	new_projectile = new_projectile.with_data(velocity,hit_data)
