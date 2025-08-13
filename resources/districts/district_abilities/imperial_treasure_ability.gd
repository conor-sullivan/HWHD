extends BaseDistrictAbility
class_name ImperialTreasureAbility

func get_end_game_bonus_points(card: DistrictData, player: Player) -> int:
	"""Gain 1 bonus point for each gold at end of game"""
	return player.gold_count