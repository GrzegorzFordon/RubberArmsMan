class_name AnimationTreeController
extends AnimationTree

const BLEND_FULL = "full_blend"
const BLEND_FILTERED = "filtered_blend"
const ONE_SHOT_FULL = "full_one_shot"
const ONE_SHOT_FILTERED = "filtered_one_shot"

func set_animation(animation_name:String,is_filtered:bool,is_one_shot:bool):
	if animation_name=="":return
	if is_one_shot:
		var node_name = (ONE_SHOT_FILTERED if is_filtered else ONE_SHOT_FULL) 
		var node_path = "parameters/"+node_name+"/request"
		tree_root.get_node(node_name+ "_animation").animation = animation_name
		set(node_path,AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		var node_name = BLEND_FILTERED if is_filtered else BLEND_FULL 
		var node_path = "parameters/"+node_name+"/blend_amount"
		tree_root.get_node(node_name+ "_animation").animation = animation_name
		set(node_path,1)

func reset_params():
	pass
