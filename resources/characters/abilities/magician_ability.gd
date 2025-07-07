class_name MagicianAbility extends Ability


func _ready() -> void:
	GameEvents.done_selecting_magician_discards.connect(_on_done_selecting_magician_discards)
	GameEvents.requested_discard_magician_ability.connect(_on_requested_discard_magician_ability)


func player_do_ability() -> void:
	GameEvents.starting_magician_ability.emit()


func ai_do_ability() -> void:
	return


func _on_requested_discard_magician_ability() -> void:
	pass


func _on_done_selecting_magician_discards(cards_to_discard : Array[DistrictCard2D]) -> void:
	var number_of_cards_to_draw = cards_to_discard.size() 

	print('over here')

	GameEvents.requested_player_discard_cards.emit(GameData.current_battle.current_players_turn, cards_to_discard)
	GameEvents.requested_player_draw_district_cards.emit(GameData.current_battle.current_players_turn, number_of_cards_to_draw)