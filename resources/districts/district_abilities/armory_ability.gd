extends BaseDistrictAbility
class_name ArmoryAbility

func get_warlord_cost_modifier(card: DistrictData, player: Player) -> int:
	"""Reduces warlord destruction cost by 1"""
	return -1