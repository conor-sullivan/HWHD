class_name MerchantAbility extends Ability


func player_do_ability() -> void:
	GameData.current_battle.real_player.gold_count += 1
	GameEvents.player_gained_gold.emit(GameData.current_battle.real_player, 1)
	gain_gold_for_districts()

	GameData.current_battle.real_player.can_use_character_ability = false


func opponent_do_ability() -> void:
	GameData.current_battle.opponent_player.gold_count += 1
	GameEvents.player_gained_gold.emit(GameData.current_battle.opponent_player, 1)
	gain_gold_for_districts()

	GameEvents.done_with_opponent_ability.emit()
	GameData.current_battle.opponent_player.can_use_character_ability = false

func gain_gold_for_districts() -> void:
	for d in GameData.current_battle.current_players_turn.district_cards_in_play:
		if d.color == 'Green':
			GameData.current_battle.current_players_turn.gold_count += 1
			GameEvents.player_gained_gold.emit(GameData.current_battle.current_players_turn, 1)