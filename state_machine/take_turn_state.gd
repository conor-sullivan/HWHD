class_name TakeTurnState
extends State


func enter() -> void:
	GameEvents.started_player_turn_state.emit()
	print('take turn state')
