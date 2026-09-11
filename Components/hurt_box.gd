class_name HurtBox
extends Area3D

signal hit_received(hit_data:HitData)
signal explosion_received(explosion_data:ExplosionData)

func on_hit(hit_data:HitData):
	hit_received.emit(hit_data)

func on_explosion(explosion_data:ExplosionData):
	explosion_received.emit(explosion_data)
