extends BaseDistrictAbility
class_name SchoolOfMagicAbility

func get_income_colors(card: DistrictData, player: Player) -> Array[String]:
	"""School of Magic counts as any color during income phase"""
	return ["Red", "Blue", "Green", "Gold", "Purple"]