class_name TakeTurnState
extends State

var current_player : Player


func enter() -> void:
	GameEvents.player_played_district_card.connect(_on_player_played_district_card)
	GameEvents.started_player_turn_state.emit()
	
	for player in GameData.current_battle.players:
		if player.is_king:
			current_player = player
	
	GameData.current_battle.current_players_turn = current_player
	current_player.can_play_district_card = true
	

func _on_player_played_district_card(card : DistrictData) -> void:
	var current_gold = current_player.gold_count
	current_player.gold_count = current_gold - card.cost
	
	GameEvents.player_spent_gold.emit(current_player, card.cost)
	
	current_player.districts_played_this_turn += 1
	current_player.district_cards_in_play += [card]
