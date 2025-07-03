class_name KingAbility extends Ability


func player_do_ability() -> void:
	GameData.current_battle.real_player.is_king = true
	GameData.current_battle.opponent_player.is_king = false

	gain_gold_for_districts()

func opponent_do_ability() -> void:
	GameData.current_battle.real_player.is_king = false
	GameData.current_battle.opponent_player.is_king = true

	gain_gold_for_districts()


func gain_gold_for_districts() -> void:
	for d in GameData.current_battle.current_players_turn.district_cards_in_play:
		if d.color == 'Gold':
			GameData.current_battle.current_players_turn.gold_count += 1
			GameEvents.player_gained_gold.emit(GameData.current_battle.current_players_turn, 1)