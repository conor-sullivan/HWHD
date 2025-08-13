extends BaseDistrictAbility
class_name LighthouseAbility

var ability_used: bool = false

func on_district_played(card: DistrictData, player: Player, played_card: DistrictData) -> void:
	"""When Lighthouse is played, trigger its ability"""
	if played_card == card and not ability_used:
		ability_used = true
		_trigger_lighthouse_ability(player)

func _trigger_lighthouse_ability(player: Player) -> void:
	"""Look through deck, choose 1 card, place in hand, shuffle deck"""
	# This would need to be implemented with UI for card selection
	# For now, we'll emit a signal that the game can handle
	GameEvents.requested_gain_card_action.emit(player)
	emit_ability_notification(player, "activated Lighthouse ability")