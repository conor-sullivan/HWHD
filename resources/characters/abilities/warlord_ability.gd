class_name WarlordAbility extends Ability

var ai = AI.new()

func player_do_ability() -> void:
	gain_gold_for_districts()
	update_player_data()
	GameEvents.warlord_ability_activated.emit()
	GameData.current_battle.real_player.can_use_character_ability = false


func opponent_do_ability() -> void:
	GameEvents.warlord_ability_activated.emit()
	gain_gold_for_districts()
	update_player_data()
	setup_ai()

	var district_to_destroy = ai.choose_warlord_target()
	if district_to_destroy:
		destroy_district(GameData.current_battle.opponent_player, district_to_destroy)
	else:
		choose_no_target()

	GameData.current_battle.opponent_player.can_use_character_ability = false
	GameEvents.done_with_opponent_ability.emit()


func gain_gold_for_districts() -> void:
	for d in GameData.current_battle.current_players_turn.district_cards_in_play:
		if d.color == 'Red':
			GameData.current_battle.current_players_turn.gold_count += 1
			GameEvents.player_gained_gold.emit(GameData.current_battle.current_players_turn, 1)


func update_player_data() -> void:
	var warlord_gold_count = GameData.current_battle.current_players_turn.gold_count
	for p in GameData.current_battle.players:
		var target_count : int = 0
		for c in p.district_cards_in_play:
			if c.cost <= (warlord_gold_count - 1):
				target_count += 1
		
		p.district_cards_targetable_by_warlord_count = target_count


func setup_ai() -> void:
	var ai_player = GameData.current_battle.opponent_player
	var real_player = GameData.current_battle.real_player
	
	var crown_holder : Player
	var player_order : Array[Player]
	
	if ai_player.is_king:
		crown_holder = ai_player
		player_order.append(ai_player)
		player_order.append(real_player)
	else:
		crown_holder = real_player
		player_order.append(real_player)
		player_order.append(ai_player)
		
		
	ai.set_player_states(ai_player, real_player)
	ai.set_game_state(player_order, crown_holder, GameData.current_battle.round_number)
	
	ai.difficulty = GameData.current_battle.difficulty 


func destroy_district(_warlord_player : Player, _card : DistrictData) -> void:
	GameEvents.player_spent_gold.emit(_warlord_player, _card.cost)
	GameEvents.warlord_ability_done.emit()
	_warlord_player.gold_count -= _card.cost
	GameEvents.requested_district_destroyed_by_opponent.emit(_card)
	GameEvents.requested_new_in_battle_notification.emit(_warlord_player.player_name, null, ' destroyed ', _card.district_name)


func choose_no_target() -> void:
	GameEvents.requested_new_in_battle_notification.emit('Warlord ', null, 'selected no targets', '')
	GameEvents.warlord_ability_done.emit()
