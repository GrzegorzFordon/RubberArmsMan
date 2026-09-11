class_name Arms
extends Node3D

enum Hand {LEFT,RIGHT}

@export var arms_dict:Dictionary[Hand,Arm]

func set_arm_action(hand:Hand, action:Arm.Action):
	arms_dict[hand].set_action(action)

func set_arm_target_position(hand:Hand, pos:Vector3):
	arms_dict[hand].set_target_position(pos)


#######
#@export var player:Player
#func _ready() -> void:
	#for arm in arms_dict.values():
		#
#Grappling
#func update_grappling_visuals():""
	#for hand in Grappling.Hand.values():
		#if not player.grappling.active_grappling_targets.has(hand):continue
		#var goal_pos = player.grappling.active_grappling_targets[hand].get_world_pos_with_offset()
		#var fraction = player.grappling.get_fraction(hand)
		#var pos = lerp(grapple_target_markers[hand].global_position,goal_pos,fraction)
		#grapple_target_markers[hand].global_position = pos
#func play_hand_scale_tween(scale_up:bool,hand:Grappling.Hand,launch_duration:float):
	#if scale_up: grapple_target_markers[hand].global_position = hand_bone_attachments[hand].global_position
	#if hand_scale_tweens.has(hand) and hand_scale_tweens[hand].is_running(): hand_scale_tweens[hand].stop()
	#var relevant_scale = 10.0 if scale_up else 1.0
	#hand_scale_tweens[hand] = get_tree().create_tween().set_parallel()
	#hand_scale_tweens[hand].tween_property(grapple_target_markers[hand],"scale",Vector3.ONE*relevant_scale,launch_duration)
	#hand_scale_tweens[hand].tween_property(copy_transform_modifiers[hand],"settings/0/amount",1 if scale_up else 0,launch_duration)
	#hand_scale_tweens[hand].tween_property(finger_ik_dict[hand],"influence",0.7 if scale_up else 0,launch_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#if not scale_up: hand_scale_tweens[hand].finished.connect(func():grapple_target_markers[hand].global_position = hand_bone_attachments[hand].global_position)
	#hand_scale_tweens[hand].play()
	#grapple_targets[hand] = target
	#play_hand_scale_tween(target != null,hand,launch_duration)
#FloorJump
#func update_floor_jump_visuals():
	#for hand in Grappling.Hand.values():
		#
#Interaction
#func set_interacting(is_interacting:bool):
	#finger_ik_dict[Grappling.Hand.LEFT].influence = 1.0 if is_interacting else 0.0
	#copy_transform_modifiers[Grappling.Hand.LEFT].influence = 1.0 if is_interacting else 0.0
#
#func set_interact_target_position(goal_position:Vector3):
	#interact_target_markers[Grappling.Hand.LEFT].global_position = goal_position
#
#func set_hand_open(factor:float):
	#factor = clampf(factor,0.0,1.0)
#
#func hold(object:Node3D):
	#object.reparent(hand_bone_attachments[Grappling.Hand.LEFT])
