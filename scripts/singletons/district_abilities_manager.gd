extends Node

# Central manager for all district abilities
# Handles triggering abilities at appropriate game events

var players_with_abilities: Dictionary = {}

func _ready() -> void:
	# Connect to all relevant game events
	GameEvents.end_player_turn.connect(_on_player_turn_ended)
	GameEvents.player_gained_gold.connect(_on_player_gained_gold)
	GameEvents.player_spent_gold.connect(_on_player_spent_gold)
	GameEvents.requested_player_rob_player.connect(_on_player_robbed)
	GameEvents.district_card_destroyed_by_warlord.connect(_on_district_destroyed)
	GameEvents.warlord_ability_activated.connect(_on_warlord_ability_activated)
	GameEvents.requested_gain_card_action.connect(_on_gain_card_action)
	GameEvents.player_played_district_card.connect(_on_district_played)
	GameEvents.players_character_card_selected.connect(_on_character_selected)
	GameEvents.opponents_character_card_selected.connect(_on_character_selected)

func register_player_abilities(player: Player) -> void:
	"""Register all abilities for a player based on their districts in play"""
	players_with_abilities = {}
	players_with_abilities[player] = []
	
	for district in player.district_cards_in_play:
		if district.ability_script != null:
			players_with_abilities[player].append({
				"district": district,
				"ability": district.ability_script
			})

func _on_player_turn_ended(player: Player) -> void:
	"""Trigger end-of-turn abilities"""
	register_player_abilities(player)
	
	if player in players_with_abilities:
		for ability_data in players_with_abilities[player]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			# Check if ability has end of turn method
			if ability.has_method("on_end_of_turn"):
				ability.on_end_of_turn(district, player)

func _on_player_gained_gold(player: Player, amount: int) -> void:
	"""Trigger abilities when player gains gold"""
	register_player_abilities(player)
	
	if player in players_with_abilities:
		for ability_data in players_with_abilities[player]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			if ability.has_method("on_gold_gained"):
				ability.on_gold_gained(district, player, amount)

func _on_player_spent_gold(player: Player, amount: int) -> void:
	"""Trigger abilities when player spends gold"""
	register_player_abilities(player)
	
	if player in players_with_abilities:
		for ability_data in players_with_abilities[player]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			if ability.has_method("on_gold_spent"):
				ability.on_gold_spent(district, player, amount)

func _on_player_robbed(robbing_player: Player, robbed_player: Player) -> void:
	"""Trigger abilities when player is robbed"""
	register_player_abilities(robbed_player)
	
	if robbed_player in players_with_abilities:
		for ability_data in players_with_abilities[robbed_player]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			if ability.has_method("on_robbed"):
				ability.on_robbed(district, robbed_player, robbing_player)

func _on_district_destroyed(card_owner: Player, card: DistrictData) -> void:
	"""Trigger abilities when a district is destroyed"""
	register_player_abilities(card_owner)
	
	if card_owner in players_with_abilities:
		for ability_data in players_with_abilities[card_owner]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			if ability.has_method("on_district_destroyed"):
				ability.on_district_destroyed(district, card_owner, card)

func _on_warlord_ability_activated() -> void:
	"""Trigger abilities when warlord ability is used"""
	# Check all players for warlord-related abilities
	for player in [GameData.current_battle.current_players_turn, GameData.current_battle.opponent_player]:
		register_player_abilities(player)
		
		if player in players_with_abilities:
			for ability_data in players_with_abilities[player]:
				var ability = ability_data.ability
				var district = ability_data.district
				
				if ability.has_method("on_warlord_ability_used"):
					ability.on_warlord_ability_used(district, player)

func _on_gain_card_action(player: Player) -> void:
	"""Trigger abilities when player gains cards"""
	register_player_abilities(player)
	
	if player in players_with_abilities:
		for ability_data in players_with_abilities[player]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			if ability.has_method("on_gain_card_action"):
				ability.on_gain_card_action(district, player)

func _on_district_played(card: DistrictData) -> void:
	"""Trigger abilities when a district is played"""
	## Find which player played this card
	#var player = null
	#if GameData.current_battle.current_players_turn.district_cards_in_play.has(card):
		#player = GameData.current_battle.current_players_turn
	#elif GameData.current_battle.opponent_player.district_cards_in_play.has(card):
		#player = GameData.current_battle.opponent_player
	
	var player = GameData.current_battle.current_players_turn
	
	if player:
		register_player_abilities(player)
		
		if player in players_with_abilities:
			for ability_data in players_with_abilities[player]:
				var ability = ability_data.ability
				var district = ability_data.district
				
				if ability.has_method("on_district_played"):
					ability.on_district_played(district, player, card)

func _on_character_selected(character: CharacterData) -> void:
	"""Trigger abilities when character is selected"""
	# Check all players for character-related abilities
	for player in GameData.current_battle.players:
		register_player_abilities(player)
		
		if player in players_with_abilities:
			for ability_data in players_with_abilities[player]:
				var ability = ability_data.ability
				var district = ability_data.district
				
				if ability.has_method("on_character_selected"):
					ability.on_character_selected(district, player, character)

func can_district_be_destroyed(district: DistrictData, owner: Player) -> bool:
	"""Check if a district can be destroyed (for Keep ability)"""
	if district.ability_script != null and district.ability_script.has_method("can_be_destroyed"):
		return district.ability_script.can_be_destroyed(district, owner)
	return true

func get_warlord_destruction_cost_modifier(player: Player) -> int:
	"""Get cost modifier for warlord destruction (for Armory ability)"""
	register_player_abilities(player)
	var modifier = 0
	
	if player in players_with_abilities:
		for ability_data in players_with_abilities[player]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			if ability.has_method("get_warlord_cost_modifier"):
				modifier += ability.get_warlord_cost_modifier(district, player)
	
	return modifier

func get_end_game_bonus_points(player: Player) -> int:
	"""Calculate bonus points at end of game"""
	register_player_abilities(player)
	var bonus_points = 0
	
	if player in players_with_abilities:
		for ability_data in players_with_abilities[player]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			if ability.has_method("get_end_game_bonus_points"):
				bonus_points += ability.get_end_game_bonus_points(district, player)
	
	return bonus_points

func get_district_colors_for_income(player: Player, district: DistrictData) -> Array[String]:
	"""Get colors that a district counts as for income (for School of Magic)"""
	if district.ability_script != null and district.ability_script.has_method("get_income_colors"):
		return district.ability_script.get_income_colors(district, player)
	return [district.color]

func can_player_take_turn_when_assassinated(player: Player) -> bool:
	"""Check if player can take turn when assassinated (for Hospital)"""
	register_player_abilities(player)
	
	if player in players_with_abilities:
		for ability_data in players_with_abilities[player]:
			var ability = ability_data.ability
			var district = ability_data.district
			
			if ability.has_method("can_take_turn_when_assassinated"):
				if ability.can_take_turn_when_assassinated(district, player):
					return true
	
	return false
