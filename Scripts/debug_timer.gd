extends Control

var timer := 0.0
var enabled := false

@export var label: Label

func _process(delta: float) -> void:
	if enabled: timer += delta
	label.text = str(timer)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("HIDE_HELP"):
		if not enabled: timer = 0.0
		enabled = !enabled
