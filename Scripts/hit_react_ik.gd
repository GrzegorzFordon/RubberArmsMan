class_name HitReactIK
extends FABRIK3D

@export var marker: Node3D
@export var mult:=1.0
#Spring
@export var spring_stiffness:=5.0
@export var spring_damping:=5.0
var spring_velocity:=Vector3.ZERO
var displacement:=Vector3.ZERO
var offset = Vector3(0,1.6,0)

func _on_force_receiver_force_received(current_force) -> void:
	current_force.y = 1.6
	print(current_force)
	spring_velocity += current_force * mult
	influence = 1

func update(delta):
	var force = SpringUtil.hookes_law(displacement,spring_velocity,spring_stiffness,spring_damping)
	spring_velocity = -force * delta
	displacement += spring_velocity
	marker.position = displacement + offset
