class_name Arm
extends Node3D

#other scripts have access to arms and set their actions
#arm is also a resource (if arm action is not idle)

enum Action {GRAPPLING,CARRYING,ATTACKING,WALLRUNNING,IDLE}
var current_action := Action.IDLE

@export var hand:Arms.Hand
@export var target_marker: Marker3D
@export var hand_bone_attachment: BoneAttachment3D
@export var copy_transform_modifier: CopyTransformModifier3D
@export var finger_ik: FABRIK3D
@export var target_marker_pivot: Node3D
@export var hand_remote: RemoteTransform3D
@export var hit_box: HitBox

var active_grappling_target:GrapplingTarget
var scale_tween:Tween

var goal_copy_amount:=0.0
var goal_open_amount:=0.0
var goal_scale_amount:=0.0

var cached_copy_amount:=0.0
var cached_open_amount:=0.0
var cached_scale_amount:=0.0

@export var copy_curve:Curve

var time_in_state:=0.0

func _ready() -> void:
	copy_transform_modifier.set_reference_node(0,target_marker.get_path())
	hand_remote.remote_path = hit_box.get_path()

func _process(delta: float) -> void:
	time_in_state += delta
	var weight = get_fraction()
	var curve_val = copy_curve.sample(weight)
	var lerped_open = lerp(cached_open_amount,goal_open_amount,curve_val)
	var lerped_copy = lerp(cached_copy_amount,goal_copy_amount,curve_val)
	var lerped_scale = lerp(cached_scale_amount,goal_scale_amount,curve_val) + 1

	copy_transform_modifier.set_amount(0,lerped_copy)
	target_marker.scale = Vector3.ONE * lerped_scale * 2.0
	finger_ik.influence = lerped_open

func set_action(action:Arm.Action):
	time_in_state = 0.0
	cached_copy_amount=copy_transform_modifier.get_amount(0)
	cached_open_amount=finger_ik.influence
	cached_scale_amount=target_marker.scale.length()
	#if action == current_action: return
	current_action = action
	var copy_amount = 0 if action == Arm.Action.IDLE else 1
	set_copy_amount(copy_amount)
	if action == Arm.Action.IDLE:
		set_open_amount(copy_amount)


func set_target_position(pos:Vector3):
	target_marker_pivot.global_position = pos

func set_copy_amount(val):
	goal_copy_amount = val

func set_open_amount(val:float):
	goal_open_amount = val

func set_scale_amount(val:float):
	goal_scale_amount = val

func get_fraction():
	var fraction = time_in_state / 0.1
	fraction = clamp(fraction,0.0,1.0)
	return fraction
