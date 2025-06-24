class_name PlayerTurnState
extends State

var player : Player


func enter() -> void:
	print('player turn state')

	GameEvents.player_played_district_card.connect(_on_player_played_district_card)
	GameEvents.started_player_turn_state.emit()
	
	player = GameData.current_battle.real_player
	player.can_play_district_card = true
	player.can_use_character_ability = true
	player.character_avatar_visible = true


func _on_player_played_district_card(card : DistrictData) -> void:
	var current_gold = player.gold_count
	player.gold_count = current_gold - card.cost
	
	GameEvents.player_spent_gold.emit(player, card.cost)
	
	player.districts_played_this_turn += 1
	player.district_cards_in_play += [card]
