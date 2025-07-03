class_name OpponentTurnState
extends State

var player : Player
@export var player_turn_state : State


func enter() -> void:
	print('opponent turn state')

	GameEvents.player_played_district_card.connect(_on_player_played_district_card)
	GameEvents.started_player_turn_state.emit()
	
	player = GameData.current_battle.opponent_player
	player.can_play_district_card = true
	player.can_use_character_ability = true
	player.character_avatar_visible = true


func process_frame(_delta :  float) -> State:
	return player_turn_state


func _on_player_played_district_card(card : DistrictData) -> void:
	var current_gold = player.gold_count
	player.gold_count = current_gold - card.cost
	
	GameEvents.player_spent_gold.emit(player, card.cost)
	
	player.districts_played_this_turn += 1
	player.district_cards_in_play += [card]
