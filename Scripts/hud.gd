class_name HUD
extends CanvasLayer

enum CROSS_HAIR_TYPE {BASE,TARGET,GRAPPLING}

@export var player: Player

@export var cross_hair_texture_rect: TextureRect
@export var cross_hair_texture_rect_alt: TextureRect
@export var cross_hair_texture_rect_combat: TextureRect

@export var stamina_progress_bars: Dictionary[Arms.Hand,TextureProgressBar]
@export var stamina_gradient: Gradient

@export var cross_hair_color:Color
@export var interaction_cross_hair_color:Color
@export var combat_cross_hair_color:Color

@export var cross_hair_base:Texture2D
@export var cross_hair_target:Texture2D
@export var cross_hair_grappling:Texture2D

@export var song_name_label: Label
var song_name_label_tween:Tween

@export var help_panel: Panel
@export var panel_2: Panel

@export var speed_lines_rect: ColorRect


func _ready() -> void:
	MusicPlayer.new_song_started.connect(set_song_name_label)
	for hand in Arms.Hand.values():
		player.stamina_meters[hand].value_changed.connect(_on_stamina_meter_value_changed.bind(hand))

func _process(delta: float) -> void:
	_update_speed_lines(delta)

func set_cross_hair(type:CROSS_HAIR_TYPE):
	var relevant_cross_hair = cross_hair_base
	var relevant_color = Color.BLACK
	match type:
		CROSS_HAIR_TYPE.BASE:
			relevant_cross_hair = cross_hair_base
			relevant_color.a = 0.3
		CROSS_HAIR_TYPE.TARGET:
			relevant_cross_hair = cross_hair_target
			relevant_color = cross_hair_color
		CROSS_HAIR_TYPE.GRAPPLING:
			relevant_cross_hair = cross_hair_grappling
			relevant_color.a = 0.3
	cross_hair_texture_rect.texture = relevant_cross_hair
	cross_hair_texture_rect.self_modulate = lerp(cross_hair_texture_rect.self_modulate,relevant_color,20.0*get_process_delta_time()/Engine.time_scale)

func set_interaction_cross_hair(is_active:bool):
	var goal_color = interaction_cross_hair_color if is_active else Color.TRANSPARENT
	cross_hair_texture_rect_alt.self_modulate = lerp(cross_hair_texture_rect_alt.self_modulate,goal_color,20.0*get_process_delta_time()/Engine.time_scale)

func set_combat_cross_hair(is_active:bool):
	var goal_color = combat_cross_hair_color if is_active else Color.TRANSPARENT
	var lerp_color = lerp(cross_hair_texture_rect_combat.modulate,goal_color,20.0*get_process_delta_time()/Engine.time_scale)
	cross_hair_texture_rect_combat.modulate = lerp_color

func set_song_name_label(song_name:String):
	print(song_name)
	song_name_label.text = "NOW PLAYING: " + song_name
	song_name_label.modulate = Color.WHITE
	if song_name_label_tween and song_name_label_tween.is_running(): song_name_label_tween.stop()
	song_name_label_tween = get_tree().create_tween()
	song_name_label_tween.tween_property(song_name_label,"modulate",Color(1,1,1,0),5.0)

func _on_stamina_meter_value_changed(val:float,hand:Arms.Hand):
	stamina_progress_bars[hand].value = val
	stamina_progress_bars[hand].visible = val != 100
	stamina_progress_bars[hand].modulate = stamina_gradient.sample(val/100.0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("INTERACT"):
		help_panel.visible = !help_panel.visible
		panel_2.visible = !panel_2.visible

func _update_speed_lines(delta):
	var speed = (player.velocity*Vector3(1,0,1)).length()
	var dot_to_camera = player.velocity.normalized().dot(-player.camera.global_basis.z)
	speed *= max(dot_to_camera,0.0)
	speed = remap(speed,0,70,0.0,0.3)
	var shader_mat = speed_lines_rect.material as ShaderMaterial
	var cur_density = shader_mat.get_shader_parameter("line_density")
	var lerped_density = lerp(cur_density,speed,10.0*delta)
	shader_mat.set_shader_parameter("line_density",speed)
