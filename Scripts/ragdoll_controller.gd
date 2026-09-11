class_name RagdollController
extends PhysicalBoneSimulator3D

@export var ragdoll_skeleton: Skeleton3D
@export var animated_skeleton: Skeleton3D

@export var linear_spring_stiffness:float=2.0
@export var linear_spring_damping:float=0.2
@export var angular_spring_stiffness:float=2.0
@export var angular_spring_damping:float=0.2
#@export var active_bones_arr:Array[PhysicalBone3D]

var physics_bones

func _ready() -> void:
	physics_bones = get_children(true).filter(func(val):return val is PhysicalBone3D)
	#var names = active_bones_arr.map(func(val:PhysicalBone3D):return val.name)
	#physical_bones_start_simulation(names)
	physical_bones_start_simulation()

func _on_modification_processed() -> void:
	_update_physics_bones()
	#_update()
	pass

func _update() -> void:
	for b in physics_bones:
			var target_transform: Transform3D = ragdoll_skeleton.global_transform * ragdoll_skeleton.get_bone_global_pose(b.get_bone_id())
			var current_transform: Transform3D = animated_skeleton.global_transform * animated_skeleton.get_bone_global_pose(b.get_bone_id())

			var position_difference:Vector3 = target_transform.origin - current_transform.origin
			var force: Vector3 = hookes_law(position_difference, b.linear_velocity, linear_spring_stiffness, linear_spring_damping)
			
			var rotation_difference: Basis = (target_transform.basis * current_transform.basis.inverse())
			var torque :Vector3 = hookes_law(rotation_difference.get_euler(), b.angular_velocity, angular_spring_stiffness, angular_spring_damping)
			
			b.linear_velocity += force
			b.angular_velocity += torque



func _update_physics_bones():
	if not physics_bones:return
	var delta = get_physics_process_delta_time()
	for bone in physics_bones as Array[PhysicalBone3D]:
		var bone_id = bone.get_bone_id()
		var target_transform = animated_skeleton.global_transform * animated_skeleton.get_bone_global_pose(bone_id)*bone.body_offset
		#var target_transform = animated_skeleton.global_transform * animated_skeleton.get_bone_global_pose(bone_id)
		#var target_transform = animated_skeleton.get_bone_global_pose(bone_id)*bone.body_offset
		
		var current_transform = ragdoll_skeleton.global_transform * ragdoll_skeleton.get_bone_global_pose(bone_id)*bone.body_offset
		#var current_transform = ragdoll_skeleton.global_transform * ragdoll_skeleton.get_bone_global_pose(bone_id)
		#var current_transform =  ragdoll_skeleton.get_bone_global_pose(bone_id)*bone.body_offset
		#var current_transform = bone.global_transform
		#var pose = global_transform.affine_inverse()*(target_transform.interpolate_with(current_transform.rotated(Vector3.MODEL_TOP,-PI/2.0),0.5))
		#self.get_skeleton().set_bone_global_pose(bone_id,pose)
		var position_difference = target_transform.origin - current_transform.origin
		var force = hookes_law(position_difference,bone.linear_velocity,linear_spring_stiffness,linear_spring_damping)
		if position_difference.length() > 1.0 and false:
			bone.global_position = target_transform.origin
			bone.basis = target_transform.basis
		else:
			bone.linear_velocity += force
			
		var rotation_difference = animated_skeleton.basis * ragdoll_skeleton.basis.inverse()
		var torque = hookes_law(rotation_difference.get_euler(),bone.angular_velocity,angular_spring_stiffness,angular_spring_damping)
		bone.angular_velocity += torque

func hookes_law(displacement,current_velocity,stiffness,damping):
	return (stiffness * displacement)-(damping*current_velocity)

#
#func _on_general_skeleton_skeleton_updated() -> void:
	#_update_physics_bones()
	#pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("HIDE_HELP"):
		if is_simulating_physics(): physical_bones_stop_simulation()
		else: physical_bones_start_simulation()
