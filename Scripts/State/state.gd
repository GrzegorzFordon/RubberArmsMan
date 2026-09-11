class_name State
extends Node

signal transition(state:State,data:Dictionary)

func enter(_data=null)->void:
	pass

func exit()->void:
	pass

func tick(_delta)->void:
	pass

func physics_tick(_delta)->void:
	pass
