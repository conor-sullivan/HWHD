class_name InitializeTurnState
extends State

@export var player_turn_state : State
@export var opponent_turn_state : State

var current_player : Player


func enter() -> void:
	print('initialize turn state')
	
	GameData.current_battle.round_number += 1
	GameData.current_battle.character_cards = GameData.current_battle.original_character_cards.duplicate()
	
	for player in GameData.current_battle.players:
		if player.is_king:
			current_player = player
	
	current_player = get_priority_player()
	
	GameData.current_battle.current_players_turn = current_player


func process_frame(_delta : float) -> State:
	if current_player:
		if current_player.is_computer:
			return opponent_turn_state
		else:
			return player_turn_state
	else:
		return null


func get_priority_player() -> Player:
	var priority_number = 10
	var priority_player : Player
	
	for player in GameData.current_battle.players:
		if player.current_character_card.play_order_number < priority_number:
			priority_player = player
			priority_number = player.current_character_card.play_order_number
	
	return priority_player
