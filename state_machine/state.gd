extends Node
class_name State

var parent : Node


func enter() -> void:
	pass


func exit() -> void:
	pass


func process_physics(_delta : float) -> State:
	return null


func process_input(_event : InputEvent) -> State:
	return null


func process_frame(_delta : float) -> State:
	return null
