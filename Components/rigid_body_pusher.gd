class_name RigidBodyPusher
extends Node

@export var player: Player
@export var player_weight := 80
@export var push_mult := 2.0

func push_away_rigid_bodies():
	for i in player.get_slide_collision_count():
		var slide_col = player.get_slide_collision(i)
		var col = slide_col.get_collider()
		var normal = slide_col.get_normal()
		var pos = slide_col.get_position()
		if col is RigidBody3D:
			var push_direction = -normal
			var mass_ratio = min(1.,player_weight/col.mass)
			var push_force = mass_ratio * push_mult
			push_direction.y = 0
			col.apply_impulse(push_direction * push_force,pos-col.global_position)
