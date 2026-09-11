class_name Interactable
extends Node

signal look_at_started(interactor:Interactor)
signal look_at_ended(interactor:Interactor)

signal interact_started(interactor:Interactor)
signal interact_ended(interactor:Interactor)

var is_interacting := false

func start_look_at(interactor:Interactor):
	look_at_started.emit(interactor)

func end_look_at(interactor:Interactor):
	look_at_ended.emit(interactor)

func start_interact(interactor:Interactor):
	is_interacting = true
	interact_started.emit(interactor)

func stop_interact(interactor:Interactor):
	is_interacting = false
	interact_ended.emit(interactor)
