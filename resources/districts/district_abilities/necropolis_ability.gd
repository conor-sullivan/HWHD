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
	player.is_doing_necropolis_ability = true
	emit_ability_notification(player, "can destroy a district instead of paying cost")

	if player == GameData.current_battle.real_player:
		GameEvents.trigger_necropolis_ability.emit(player)
		return

	var cheapest_district : DistrictData = null
	for d in player.district_cards_in_play:
		if cheapest_district == null or d.cost < cheapest_district.cost:
			cheapest_district = d
		
	if not cheapest_district:
		GameEvents.necropolis_chose_no_targets.emit(player)
		GameEvents.requested_new_in_battle_notification.emit('Necropolis ', null, 'selected no targets', '')
		return
	
	GameEvents.requested_district_destroyed_by_opponent.emit(cheapest_district)
