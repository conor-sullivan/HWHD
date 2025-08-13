extends BaseDistrictAbility
class_name NecropolisAbility

var ability_used: bool = false

func on_district_played(card: DistrictData, player: Player, played_card: DistrictData) -> void:
	"""When Necropolis is played, can destroy any district in your city instead of paying cost"""
	if played_card == card and not ability_used:
		ability_used = true
		_trigger_necropolis_ability(player)

func _trigger_necropolis_ability(player: Player) -> void:
	"""Allow player to destroy one of their own districts instead of paying cost"""
	# This would need UI implementation for district selection
	# For now, we'll emit a notification
	emit_ability_notification(player, "can destroy a district instead of paying cost")