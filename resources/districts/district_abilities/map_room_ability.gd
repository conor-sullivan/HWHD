extends BaseDistrictAbility
class_name MapRoomAbility

func get_end_game_bonus_points(card: DistrictData, player: Player) -> int:
	"""Gain 1 bonus point for each card in hand at end of game"""
	return player.district_cards_in_hand.size()