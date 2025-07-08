class_name PlayerDeckCardCollection
extends CardCollection3D


func _ready() -> void:
	GameEvents.requested_gain_card_action.connect(_on_requested_gain_card_action)
	GameEvents.requested_player_draw_district_cards.connect(_on_requested_player_draw_district_cards)


func _on_requested_player_draw_district_cards(player : Player, count : int) -> void:
	if player.is_computer:
		return
	


func _on_requested_gain_card_action(player : Player) -> void:
	if GameData.current_battle.current_players_turn != player:
		return
	
	var cards_to_select_from : Array[DistrictData] = [
		(cards[cards.size() -1] as NewCard3D).resource, 
		(cards[cards.size() -2] as NewCard3D).resource
		]
	
	GameEvents.deck_cards_ready_for_gain_card_action.emit(player, cards_to_select_from)
	for card in cards_to_select_from:
		remove_card(cards.size() -1)
		remove_card(cards.size() -2)



func can_insert_card(_card: NewCard3D, _from_collection) -> bool:
	return true


func can_select_card(_card: NewCard3D) -> bool:
	return false


func can_reorder_card(_card: NewCard3D) -> bool:
	return false


func can_remove_card(_card: NewCard3D) -> bool:
	return false
