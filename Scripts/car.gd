class_name Car
extends CharacterBody3D

@export var road_lane_agent: RoadLaneAgent
#@export var body: MeshInstance3D
@export var color_arr:Array[Color]
@export var speed:=30.0
@export var audio_stream_player_3d: AudioStreamPlayer3D
@export var area_3d: Area3D

func _ready() -> void:
	_init_lane()
	area_3d.body_entered.connect(_honk)
	#var material = body.get_active_material(0) as ShaderMaterial
	#material.set_shader_parameter("ColorParameter",color_arr.pick_random())

func _process(delta: float) -> void:
	if not road_lane_agent.current_lane:road_lane_agent.assign_nearest_lane()
	if road_lane_agent.current_lane:
		var pos = road_lane_agent.move_along_lane(speed*delta)
		if global_position.distance_to(pos)<0.01:
			queue_free()
			return
		else:
			look_at(pos)
			global_position = pos

func _init_lane():
	if not road_lane_agent.is_node_ready(): await road_lane_agent.ready
	road_lane_agent.assign_actor()
	road_lane_agent.assign_nearest_lane()
	if road_lane_agent.current_lane:
		global_position = road_lane_agent.get_closest_path_point(road_lane_agent.current_lane,global_position)

func _honk(body:Node3D):
	if randf()>0.9:return
	if is_instance_of(body,Player):
		audio_stream_player_3d.play()
