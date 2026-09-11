extends Node

signal new_song_started(song_name:String)

@export var audio_stream_player: AudioStreamPlayer
@export var song_arr:Array[AudioStreamMP3]
var cur_song:AudioStreamMP3

func _ready() -> void:
	#next_song()
	audio_stream_player.finished.connect(next_song)

func play():
	audio_stream_player.play()

func pause():
	audio_stream_player.stop()

func next_song():
	cur_song = song_arr.pick_random()
	audio_stream_player.stream = cur_song
	new_song_started.emit(cur_song.resource_path.get_file())
	play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("NEXT"):next_song()
	if event.is_action_pressed("PLAYPAUSE"):
		audio_stream_player.playing = !audio_stream_player.playing
