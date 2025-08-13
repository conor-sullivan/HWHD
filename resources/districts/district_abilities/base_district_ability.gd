extends Resource
class_name BaseDistrictAbility

# Base class for all district abilities
# Provides common interface and default implementations

# Event-based ability triggers
func on_end_of_turn(card: DistrictData, player: Player) -> void:
	"""Called at the end of a player's turn"""
	pass

func on_gold_gained(card: DistrictData, player: Player, amount: int) -> void:
	"""Called when player gains gold"""
	pass

func on_gold_spent(card: DistrictData, player: Player, amount: int) -> void:
	"""Called when player spends gold"""
	pass

func on_robbed(card: DistrictData, robbed_player: Player, robbing_player: Player) -> void:
	"""Called when player is robbed"""
	pass

func on_district_destroyed(card: DistrictData, owner: Player, destroyed_card: DistrictData) -> void:
	"""Called when any district is destroyed"""
	pass

func on_warlord_ability_used(card: DistrictData, player: Player) -> void:
	"""Called when warlord ability is activated"""
	pass

func on_gain_card_action(card: DistrictData, player: Player) -> void:
	"""Called when player gains cards"""
	pass

func on_district_played(card: DistrictData, player: Player, played_card: DistrictData) -> void:
	"""Called when any district is played"""
	pass

func on_character_selected(card: DistrictData, player: Player, character: CharacterData) -> void:
	"""Called when a character is selected"""
	pass

# Query-based ability methods
func can_be_destroyed(card: DistrictData, owner: Player) -> bool:
	"""Return false to prevent destruction"""
	return true

func get_warlord_cost_modifier(card: DistrictData, player: Player) -> int:
	"""Return negative value to reduce warlord destruction cost"""
	return 0

func get_end_game_bonus_points(card: DistrictData, player: Player) -> int:
	"""Return bonus points at end of game"""
	return 0

func get_income_colors(card: DistrictData, player: Player) -> Array[String]:
	"""Return array of colors this district counts as for income"""
	return [card.color]

func can_take_turn_when_assassinated(card: DistrictData, player: Player) -> bool:
	"""Return true to allow turn when assassinated"""
	return false

# Utility methods
func emit_ability_notification(player: Player, message: String) -> void:
	"""Helper to emit ability notifications"""
	GameEvents.requested_new_in_battle_notification.emit(
		player.player_name, 
		null, 
		message, 
		""
	)