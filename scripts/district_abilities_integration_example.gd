# Example integration script showing how to use the district abilities system
# This demonstrates how to integrate the abilities manager into your existing game flow

extends Node

# Example of how to check if a district can be destroyed (for Warlord ability)
func can_destroy_district(district: DistrictData, owner: Player) -> bool:
	return DistrictAbilitiesManager.can_district_be_destroyed(district, owner)

# Example of how to get warlord cost modifier (for Armory ability)
func get_destruction_cost(base_cost: int, player: Player) -> int:
	var modifier = DistrictAbilitiesManager.get_warlord_destruction_cost_modifier(player)
	return max(0, base_cost + modifier)  # Ensure cost doesn't go below 0

# Example of how to calculate end game score with bonus points
func calculate_final_score(player: Player) -> int:
	var base_score = player.points_count
	var bonus_points = DistrictAbilitiesManager.get_end_game_bonus_points(player)
	return base_score + bonus_points

# Example of how to check if player can take turn when assassinated
func can_player_act_when_assassinated(player: Player) -> bool:
	return DistrictAbilitiesManager.can_player_take_turn_when_assassinated(player)

# Example of how to get income colors for a district (for School of Magic)
func get_district_income_colors(district: DistrictData, player: Player) -> Array[String]:
	return DistrictAbilitiesManager.get_district_colors_for_income(player, district)

# Example of how to calculate income with School of Magic
func calculate_character_income(player: Player, character_color: String) -> int:
	var income = 0
	
	for district in player.district_cards_in_play:
		var colors = get_district_income_colors(district, player)
		if character_color in colors:
			income += 1
	
	return income