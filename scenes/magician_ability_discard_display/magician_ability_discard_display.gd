class_name MagicianAbilityDiscardDisplay extends Control

@export var district_card_scene : PackedScene = preload("res://scenes/district_card_2d/district_card_2d.tscn")


func _ready() -> void:
	GameEvents.requested_show_magician_discard_display.connect(_on_requested_show_magician_discard_display)


func _on_button_pressed() -> void:
	print('discards accepted')
	var cards_to_discard : Array[DistrictData]

	for c in %CardsContainer.get_children():
		if not (c as DistrictCard2D).is_selected:
			cards_to_discard.append(c.data)

	print('cards to discard: ', cards_to_discard)
	var number_of_cards_to_draw = cards_to_discard.size() 


	print('over here')

	hide()

	GameEvents.done_selecting_magician_discards.emit(cards_to_discard)
	GameEvents.requested_player_discard_cards.emit(GameData.current_battle.current_players_turn, cards_to_discard)

	await get_tree().create_timer(0.2).timeout

	GameEvents.requested_player_draw_district_cards.emit(GameData.current_battle.current_players_turn, number_of_cards_to_draw)

	GameData.current_battle.current_players_turn.can_use_character_ability = false


func _on_requested_show_magician_discard_display() -> void:
	for c in %CardsContainer.get_children():
		c.queue_free()	
	
	for c in GameData.current_battle.current_players_turn.district_cards_in_hand:
		var instance = district_card_scene.instantiate() as DistrictCard2D
		instance.data = c

		%CardsContainer.add_child(instance)
	print('show')
	show()
