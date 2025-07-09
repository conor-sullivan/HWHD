class_name OpponentDeckCardCollection
extends CardCollection3D


func _ready() -> void:
	GameEvents.requested_opponent_gain_card_action.connect(_on_requested_opponent_gain_card_action)


func _on_requested_opponent_gain_card_action() -> void:
	var cards_to_select_from : Array[DistrictData] = [
		(cards[cards.size() -1] as NewCard3D).resource, 
		(cards[cards.size() -2] as NewCard3D).resource
		]
	print('requesting gain card actoin')
	GameEvents.opponent_deck_cards_ready_for_gain_card_action.emit(cards_to_select_from)
	print('yup', cards_to_select_from)
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
