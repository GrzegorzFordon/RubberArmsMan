class_name Portal
extends Node3D

@export var partner : Portal
@export var camera_3d: Camera3D
@export var area_3d: Area3D
@export var sub_viewport: SubViewport
@export var cull_layer : int = 7
@export var portal_mesh: CSGBox3D

var portal_candidates : Dictionary[Node3D,int]

@export var floor_lines:Array[CSGBox3D]
@export var enabled_debug:=false
@export var thickness := 20.0

func _ready() -> void:
	portal_mesh.set_layer_mask_value(1,false)
	portal_mesh.set_layer_mask_value(cull_layer,true)
	camera_3d.set_cull_mask_value(partner.cull_layer,false)
	for mesh in floor_lines:
		mesh.material.albedo_color = Color(randf(),randf(),randf())

func _process(delta: float) -> void:
	_update_camera_to_other_portal()
	_check_teleporting_candidates()
	_thicken_portal_for_near_clipping()

func _update_camera_to_other_portal():
	var cur_camera = get_viewport().get_camera_3d()
	if not cur_camera:return

	var cur_camera_transform_rel_to_this_portal = self.global_transform.affine_inverse() * cur_camera.global_transform
	var moved_to_other_camera = partner.global_transform * cur_camera_transform_rel_to_this_portal
	camera_3d.global_transform = moved_to_other_camera
	camera_3d.fov = cur_camera.fov
	camera_3d.cull_mask = cur_camera.cull_mask
	camera_3d.set_cull_mask_value(partner.cull_layer,false)
	sub_viewport.size = get_viewport().get_visible_rect().size
	sub_viewport.msaa_3d = get_viewport().msaa_3d
	sub_viewport.screen_space_aa = get_viewport().screen_space_aa
	sub_viewport.use_taa = get_viewport().use_taa
	sub_viewport.use_debanding = get_viewport().use_debanding
	sub_viewport.use_occlusion_culling = get_viewport().use_occlusion_culling
	sub_viewport.mesh_lod_threshold = get_viewport().mesh_lod_threshold

func _thicken_portal_for_near_clipping():
	var cur_camera = get_viewport().get_camera_3d()
	if not cur_camera:return
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	var up = global_transform.basis.y
	var camera_offset_from_portal = cur_camera.global_position - global_position
	var dist_from_portal_plane_forward = camera_offset_from_portal.dot(forward)
	var dist_from_portal_plane_right = camera_offset_from_portal.dot(right)
	var dist_from_portal_plane_up = camera_offset_from_portal.dot(up)
	var portal_side =_get_nonzero_sign(dist_from_portal_plane_forward)
	var half_portal_width = portal_mesh.size.x * 0.5
	var half_portal_height = portal_mesh.size.y * 0.5
	#if enabled_debug : print(dist_from_portal_plane_right)
	#var camera_facing_portal = cur_camera.global_basis.z.dot(forward)>0
	if (abs(dist_from_portal_plane_forward)>1.0
		or abs(dist_from_portal_plane_right)>half_portal_width):
		#or dist_from_portal_plane_up>half_portal_height+0.3):
		portal_mesh.size.z = 0.001
		portal_mesh.position.z = 0.0
		return
	#print(name)
	portal_mesh.size.z = thickness
	if portal_side == 1:
		portal_mesh.position.z = -thickness/2.0
	else:
		portal_mesh.position.z = thickness/2.0

func _check_teleporting_candidates():
	for candidate in portal_candidates.keys():
		var relevant_node = _get_relevant_node(candidate)
		var new_value = _get_dot_product_sign_to_body(relevant_node)
		if new_value != portal_candidates[candidate]:
			_teleport_body(candidate)
		portal_candidates[candidate] = new_value

func _on_area_3d_body_entered(body: Node3D) -> void:
	var relevant_node = _get_relevant_node(body)
	var side = _get_dot_product_sign_to_body(relevant_node)
	portal_candidates[body] = side

func _teleport_body(body:Node3D):
	var transform_rel_to_this_portal = global_transform.affine_inverse() * body.global_transform
	var moved_to_other_portal = partner.global_transform * transform_rel_to_this_portal
	body.global_transform = moved_to_other_portal
	var r = partner.global_transform.basis.get_euler()-global_transform.basis.get_euler()
	if body is CharacterBody3D:
		body.velocity = body.velocity.rotated(Vector3.LEFT,r.x).rotated(Vector3.UP,r.y).rotated(Vector3.FORWARD,r.z)
	if body is RigidBody3D:
		body.linear_velocity = body.linear_velocity.rotated(Vector3.LEFT,r.x).rotated(Vector3.UP,r.y).rotated(Vector3.FORWARD,r.z)

func _on_area_3d_body_exited(body: Node3D) -> void:
	portal_candidates.erase(body)

func _get_dot_product_sign_to_body(body:Node3D)->int:
	var forward = global_transform.basis.z
	var direction_to_body = global_position.direction_to(body.global_position)
	var dot_product = forward.dot(direction_to_body)
	var sign = _get_nonzero_sign(dot_product)
	return sign

func _get_relevant_node(body):
	var relevant_node = body
	if body is Player: relevant_node = body.camera
	return relevant_node

func _get_nonzero_sign(val):
	var s = sign(val)
	if s == 0: s = -1
	return s
