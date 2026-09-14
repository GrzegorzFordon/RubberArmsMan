class_name NoiseField
extends Field

@export var noise_texture:NoiseTexture2D

func get_tensor(point:Vector2)->Tensor:
	var noise_val = noise_texture.noise.get_noise_2d(point.x,point.y)
	var angle_rad = deg_to_rad(noise_val)
	var tensor = Tensor.new().with_data(1,[cos(noise_val*2),sin(noise_val*2)])
	return tensor
