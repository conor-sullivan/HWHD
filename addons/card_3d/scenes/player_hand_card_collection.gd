class_name PlayerHandCardCollection
extends CardCollection3D


func _ready() -> void:
	GameEvents.requested_append_card_in_player_hand.connect(_on_requested_append_card_in_player_hand)


func _on_requested_append_card_in_player_hand(player : Player, card : NewCard3D) -> void:
	if player != GameData.current_battle.real_player:
		return
	
	append_card(card)

	update_game_data()


func remove_card(index: int) -> Card3D:
	var removed_card = cards[index]
	cards.remove_at(index)
	card_indicies.erase(removed_card)
	
	for i in range(index, cards.size()):
		card_indicies[cards[i]] = i
	
	remove_child(removed_card)
	apply_card_layout()
	
	removed_card.card_3d_mouse_down.disconnect(_on_card_pressed.bind(removed_card))
	removed_card.card_3d_mouse_up.disconnect(_on_card_clicked.bind(removed_card))
	removed_card.card_3d_mouse_over.disconnect(_on_card_hover.bind(removed_card))
	removed_card.card_3d_mouse_exit.disconnect(_on_card_exit.bind(removed_card))
	
	GameData.current_battle.real_player.district_cards_in_hand.erase(removed_card.resource)
	return removed_card

	update_game_data()


func update_game_data() -> void:
	var new_hand_data : Array[DistrictData]

	for c in cards:
		new_hand_data.append(c.resource)
	
	GameData.current_battle.real_player.district_cards_in_hand = new_hand_data
