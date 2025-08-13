extends BaseDistrictAbility
class_name HospitalAbility

func can_take_turn_when_assassinated(card: DistrictData, player: Player) -> bool:
	"""Allows player to take turn even when assassinated"""
	return true
