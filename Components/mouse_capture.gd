class_name MouseCapture
extends Node

@export var action_name_capture:="INTERACT"
@export var action_name_release:="ESC"

func _input(event: InputEvent) -> void:
	if event.is_action(action_name_capture):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action(action_name_release):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
