class_name NoiseSampler
extends Node

@export var noise_texture:NoiseTexture2D

func sample(point:Vector2):
	return noise_texture.noise.get_noise_2d(point.x,point.y)
