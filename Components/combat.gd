class_name Combat
extends Node

#Combat is all the things that the player can do to enemies
#Press LMB on enemy and release to shoot a web ball
#Press LMB on enemy and swing mouse to throw them
#Grab item and throw it at them
#Ground Slam

@export var player: Player
#@export var arms: Arms

#Ground Slam
@export var ground_slam_area: Area3D
@export var collision_shape_3d: CollisionShape3D
@export var interactable_item: PackedScene

#Projectiles
@export var projectile: PackedScene
@export var projectile_speed:=50.0

#Hits
@export var combat_shape_cast: ShapeCast3D
#@export var catenary_alt: Catenary

func _process(delta: float) -> void:
	has_target()

func punch(hand:Arms.Hand):
	var can_punch = player.stamina_meters[hand].try_use(20)
	if not can_punch: return
	player.arms.set_arm_action(hand,Arm.Action.ATTACKING)
	player.arms.set_arm_target_position(hand,get_ray_target())
	pass

func slam_ground(intensity:float):
	var overlapping_areas = ground_slam_area.get_overlapping_areas()
	var overlapping_hurt_boxes = overlapping_areas.filter(func(val):return val is HurtBox)
	var explosion_data = ExplosionData.new().with_data(player.global_position,intensity,15)
	player.vfx_controller.play()
	for hurt_box in overlapping_hurt_boxes as Array[HurtBox]:
		hurt_box.on_explosion(explosion_data)
	var rnd_spawned_items_amount = randi_range(3,6)
	for i in rnd_spawned_items_amount:
		var new_interactible_item = interactable_item.instantiate() as InteractItem
		get_tree().root.add_child(new_interactible_item)
		var rnd_vector = Vector3(randf()*2-1,2,randf()*2-1) * randi_range(5,15)
		new_interactible_item.global_position = player.global_position + rnd_vector*0.05
		new_interactible_item.linear_velocity += rnd_vector

func shoot_projectile(body:Node3D=null):
	var new_projectile = projectile.instantiate() as Projectile
	get_tree().current_scene.add_child(new_projectile)
	new_projectile.global_position = player.hand_marker_left.global_position if body else player.hand_marker_right.global_position
	var forward = -player.camera.global_basis.z
	var velocity = forward * projectile_speed
	new_projectile.look_at(new_projectile.global_position + forward)
	var hit_data = HitData.new().with_data(player.global_position,10)
	new_projectile = new_projectile.with_data(velocity,hit_data)
	if body:
		body.reparent(new_projectile)
		body.position = Vector3.ZERO
		if body is RigidBody3D:
			body.collision_layer = 0
			body.collision_mask = 0
			body.freeze = true

func has_target()->bool:
	var collider_is_enemy : bool
	if combat_shape_cast.is_colliding():
		var collider = combat_shape_cast.get_collider(0) as Node
		#collider_is_enemy = is_instance_of(collider,Enemy)
		collider_is_enemy = is_instance_of(collider,HurtBox)
	player.hud.set_combat_cross_hair(collider_is_enemy)
	return collider_is_enemy

func get_target()->Enemy:
	if combat_shape_cast.is_colliding():
		var collider = combat_shape_cast.get_collider(0) as Node
		if is_instance_of(collider,Enemy): return collider
	return null

func get_ray_target()->Vector3:
	if combat_shape_cast.is_colliding():
		var col_point = combat_shape_cast.get_collision_point(0) as Vector3
		return col_point
	return Vector3.ZERO
