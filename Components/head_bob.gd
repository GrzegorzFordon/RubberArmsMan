class_name HeadBob
extends Node

@export var enabled:=true
@export var frequency_head_bob:float
@export var amplitude_head_bob:float
@export var footsteps_audio_stream: AudioStreamPlayer3D

var player
var time_head_bob := 0.0

var can_play_footstep:=false

func _ready() -> void:
	await owner.ready
	player = owner as CharacterBody3D

func _process(delta: float) -> void:
	if enabled:
		time_head_bob += delta * player.velocity.length()
		player.camera.position =  _headbob()

func _headbob():
	var pos = Vector3.ZERO
	pos.y += sin(time_head_bob*frequency_head_bob) * amplitude_head_bob
	pos.x = cos(time_head_bob*frequency_head_bob*0.5)*amplitude_head_bob
	var footstep_treshold = -amplitude_head_bob+0.001
	if pos.y > footstep_treshold:
		can_play_footstep = true
	elif pos.y < footstep_treshold and can_play_footstep:
		can_play_footstep = false
		footsteps_audio_stream.play()
	return pos
