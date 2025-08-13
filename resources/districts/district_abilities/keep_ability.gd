extends BaseDistrictAbility
class_name KeepAbility

func can_be_destroyed(card: DistrictData, owner: Player) -> bool:
	"""Keep cannot be destroyed"""
	return false