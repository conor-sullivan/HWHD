class_name MagicianAbility extends Ability


func _ready() -> void:
	GameEvents.done_selecting_magician_discards.connect(_on_done_selecting_magician_discards)


func player_do_ability() -> void:
	GameEvents.starting_magician_ability.emit()


func opponent_do_ability() -> void:
	var ai = AI.new()
	var ai_player = GameData.current_battle.opponent_player
	var player = GameData.current_battle.real_player
	
	var crown_holder : Player
	var player_order : Array[Player]
	
	if ai_player.is_king:
		crown_holder = ai_player
		player_order.append(ai_player)
		player_order.append(player)
	else:
		crown_holder = player
		player_order.append(player)
		player_order.append(ai_player)
		
		
	ai.set_player_states(ai_player, player)
	ai.set_game_state(player_order, crown_holder, GameData.current_battle.round_number)
	
	ai.difficulty = GameData.current_battle.difficulty 
	
	var result = ai.use_magician_ability()	

	if result['action'] == 'exchange':
		exchange_hands()

	if result['action'] == 'discard_draw' :
		discard_draw(result['cards_to_discard'])
	
	GameEvents.done_with_opponent_ability.emit()


func exchange_hands() -> void:
	var player_hand = GameData.current_battle.real_player.district_cards_in_hand.duplicate()
	var opponent_hand = GameData.current_battle.opponent_player.district_cards_in_hand.duplicate()

	GameData.current_battle.real_player.district_cards_in_hand = opponent_hand
	GameData.current_battle.opponent_player.district_cards_in_hand = player_hand

	GameEvents.requested_players_exchange_hands.emit()
	GameData.current_battle.real_player.can_use_character_ability = false


func discard_draw(cards_to_discard : Array[DistrictData]) -> void:
	var number_of_cards_to_draw = cards_to_discard.size() 

	GameEvents.requested_player_discard_cards.emit(GameData.current_battle.current_players_turn, cards_to_discard)
	GameEvents.requested_player_draw_district_cards.emit(GameData.current_battle.current_players_turn, number_of_cards_to_draw)


func _on_done_selecting_magician_discards(cards_to_discard : Array[DistrictData]) -> void:
	discard_draw(cards_to_discard)