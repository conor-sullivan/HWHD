extends BaseDistrictAbility
class_name BellTowerAbility

func get_end_game_bonus_points(card: DistrictData, player: Player) -> int:
	"""Grants 4 points if you have 7 districts; 2 points if you have 7 districts when others do too"""
	if player.district_cards_in_play.size() >= 7:
		# Check if other players also have 7+ districts
		var other_players_with_7_districts = 0
		var all_players = [GameData.current_battle.player, GameData.current_battle.opponent_player]
		
		for other_player in all_players:
			if other_player != player and other_player.district_cards_in_play.size() >= 7:
				other_players_with_7_districts += 1
		
		if other_players_with_7_districts > 0:
			return 2  # 2 points if others also have 7 districts
		else:
			return 4  # 4 points if only this player has 7 districts
	
	return 0