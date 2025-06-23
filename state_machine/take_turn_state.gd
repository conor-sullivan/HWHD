class_name TakeTurnState
extends State


func enter() -> void:
	GameEvents.started_player_turn_state.emit()
	var current_player : Player
	for player in GameData.current_battle.players:
		if player.is_king:
			current_player = player
	
	GameData.current_battle.current_players_turn = current_player
	GameEvents.player_data_changed.emit()
	
	GameEvents.player_played_district_card.connect(_on_player_played_district_card)


func _on_player_played_district_card(card : DistrictData) -> void:
	GameData.current_battle.current_players_turn.gold_count -= card.cost
	GameEvents.player_spent_gold.emit(GameData.current_battle.current_players_turn, card.cost)
