class_name Destructible
extends Node

signal destroyed()

func destroy():
	destroyed.emit()
	queue_free()
