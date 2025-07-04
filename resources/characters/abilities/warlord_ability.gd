class_name WarlordAbility extends Ability


func player_do_ability() -> void:
	gain_gold_for_districts()
	update_player_data()
	GameEvents.warlord_ability_activated.emit()
	GameData.current_battle.real_player.can_use_character_ability = false


func opponent_do_ability() -> void:
	gain_gold_for_districts()
	update_player_data()
	GameData.current_battle.opponent_player.can_use_character_ability = false


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