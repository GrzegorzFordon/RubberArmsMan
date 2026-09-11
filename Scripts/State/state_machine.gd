class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(transition)
	if initial_state:
		await owner.ready
		transition(initial_state.name.to_lower())

func process_inputs(input_data: InputData) -> void:
	if current_state:
		current_state.process_inputs(input_data)

func tick(delta):
	if current_state:
		current_state.tick(delta)

func physics_tick(delta):
	if current_state:
		current_state.physics_tick(delta)

func transition(new_state_name: String):
	if current_state == null:
		await get_tree().process_frame
	var new_state = states[new_state_name.to_lower()]
	if !new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
