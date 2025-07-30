extends Resource
class_name PoorHouseAbility

func on_end_of_turn(_card: DistrictData, player: Player) -> void:
	if player.gold_count == 0:
		GameEvents.do_poor_house_ability.emit()
		player.gold_count += 1
		GameEvents.player_gained_gold.emit(player, 1)