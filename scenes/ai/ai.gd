class_name AI
extends Node

enum Difficulty { BASIC, INTERMEDIATE, ADVANCED }

# --- Export Variables ---
@export var difficulty: Difficulty = Difficulty.BASIC
@export var ai_name: String = "AI Player"

# --- Game State Information (These would be passed from your game manager) ---
var available_character_cards: Array[CharacterData]  # Array of available Character card IDs/names
var ai_player_state: Player	   # Player's current gold, hand, etc.
var human_player_state: Player	# Human player's current gold, hand, etc.
var player_turn_order: Array[Player]		# Current player order (important for who gets the Crown)
var crown_holder: Player			# Name of the player holding the Crown
#var discarded_characters: Array[CharacterData]	 # Characters discarded this round
#var face_down_character: CharacterData	 # The character put face down (for 2-player rules)
var round_number: int			   # Current round number (for potential strategic changes)
var player_buildings: Array[DistrictData]	# Dictionary mapping player names to their built districts (Array of district cards)
var ai_buildings: Array[DistrictData]

# --- AI Logic ---
func choose_character():
	match difficulty:
		Difficulty.BASIC:
			return choose_character_basic() as CharacterData
		Difficulty.INTERMEDIATE:
			return choose_character_intermediate() as CharacterData
		Difficulty.ADVANCED:
			return choose_character_advanced() as CharacterData


# Basic AI: Randomly choose a character
func choose_character_basic():
	if available_character_cards.is_empty():
		return null
	return available_character_cards[randi() % available_character_cards.size()]


func choose_character_intermediate():
	if available_character_cards.is_empty():
		return null

	var best_character = null
	var best_score = -1000

	for character in available_character_cards:
		var score = 0
		var ai_gold = ai_player_state.gold_count
		var ai_hand = ai_player_state.district_cards_in_hand.size()
		var human_gold = human_player_state.gold_count
		var human_hand = human_player_state.district_cards_in_hand.size()
		var ai_built = ai_player_state.district_cards_in_play
		var human_built = human_player_state.district_cards_in_play

		# Count district types for AI
		var ai_noble = 0
		var ai_religious = 0
		var ai_trade = 0
		var ai_military = 0
		for d in ai_built:
			if d.has("color"):
				match d["color"]:
					"gold":
						ai_noble += 1
					"blue":
						ai_religious += 1
					"green":
						ai_trade += 1
					"red":
						ai_military += 1

		# Count district types for Human
		@warning_ignore("unused_variable")
		var human_noble = 0
		@warning_ignore("unused_variable")
		var human_religious = 0
		@warning_ignore("unused_variable")
		var human_trade = 0
		var human_military = 0
		var human_high_cost_built = 0
		for d in human_built:
			if d:
				match d.color:
					"Gold":
						human_noble += 1
					"Blue":
						human_religious += 1
					"Green":
						human_trade += 1
					"Red":
						human_military += 1
			if d.cost >= 4:
				human_high_cost_built += 1

		match character.character_name:
			"Assassin":
				score += 10
				if human_gold > 4 or human_hand > 3:
					score += 5
				if round_number > 3:
					score += 2
			"Thief":
				score += human_gold * 0.7
				if human_gold > 3:
					score += 4
			"Magician", "Wizard":
				if ai_hand < 2:
					score += 8
				if human_hand > 3:
					score += 5
			"King":
				if not crown_holder.is_computer:
					score += 15
				else:
					score -= 5
				score += ai_noble * 2
			"Bishop":
				score += ai_religious * 2
				if human_military > 1:
					score += 2 # Defensive if human has military
			"Merchant":
				score += ai_gold * 0.5
				score += ai_trade * 2
				if ai_hand > 2:
					score += 2
			"Warlord":
				score += 5
				score += human_high_cost_built * 3
				score += ai_military * 2
				if ai_gold > 2:
					score += 2
			_:
				score += 1

		#if character in discarded_characters:
			#score -= 10
		#if character == face_down_character:
			#score -= 10

		if score > best_score:
			best_score = score
			best_character = character

	if best_score <= 0:
		return choose_character_basic()
	return best_character


# Advanced AI: Incorporates all intermediate factors, plus considers specific district cards
func choose_character_advanced():
	if available_character_cards.is_empty():
		return null

	var best_character = null
	var best_score = -1000

	for character in available_character_cards:
		var score = 0
		var ai_gold = ai_player_state.gold_count
		var ai_hand = ai_player_state.district_cards_in_hand
		var human_gold = human_player_state.gold_count
		var human_hand = human_player_state.district_cards_in_hand
		var ai_built = ai_player_state.district_cards_in_play
		var human_built = human_player_state.district_cards_in_play

		# Count district types in AI's hand
		var ai_hand_noble = 0
		var ai_hand_religious = 0
		var ai_hand_trade = 0
		var ai_hand_military = 0
		@warning_ignore("unused_variable")
		var ai_hand_high_cost = 0
		for card in ai_hand:
			if card:
				match card.color:
					"Gold":
						ai_hand_noble += 1
					"Blue":
						ai_hand_religious += 1
					"Green":
						ai_hand_trade += 1
					"Red":
						ai_hand_military += 1
			if card.cost >= 4:
				ai_hand_high_cost += 1

		# Count district types in AI's built districts
		var ai_built_noble = 0
		var ai_built_religious = 0
		var ai_built_trade = 0
		var ai_built_military = 0
		@warning_ignore("unused_variable")
		var ai_built_high_cost = 0
		for d in ai_built:
			if d:
				match d.color:
					"Gold":
						ai_built_noble += 1
					"Blue":
						ai_built_religious += 1
					"Greeen":
						ai_built_trade += 1
					"Red":
						ai_built_military += 1
			if d.cost >= 4:
				ai_built_high_cost += 1

		# Count district types in Human's hand
		var human_hand_noble = 0
		var human_hand_religious = 0
		var human_hand_trade = 0
		var human_hand_military = 0
		var human_hand_high_cost = 0
		for card in human_hand:
			if card:
				match card.color:
					"Gold":
						human_hand_noble += 1
					"Blue":
						human_hand_religious += 1
					"Green":
						human_hand_trade += 1
					"Red":
						human_hand_military += 1
			if card.cost >= 4:
				human_hand_high_cost += 1

		# Count district types in Human's built districts
		var human_built_noble = 0
		var human_built_religious = 0
		var human_built_trade = 0
		var human_built_military = 0
		var human_built_high_cost = 0
		var human_unique_built = 0
		for d in human_built:
			if d:
				match d.color:
					"Gold":
						human_built_noble += 1
					"Blue":
						human_built_religious += 1
					"Green":
						human_built_trade += 1
					"Red":
						human_built_military += 1
			if d.cost >= 4:
				human_built_high_cost += 1
			if d.is_purple_foil:
				human_unique_built += 1

		match character.character_name:
			"Assassin":
				score += 12
				if human_gold > 4 or human_hand.size() > 3:
					score += 6
				if round_number > 3:
					score += 3
				# Predict human's likely pick (e.g., King if many nobles, Merchant if many trade, Bishop if many religious, Warlord if many military)
				if human_built_noble > 2 or human_hand_noble > 1:
					score += 4
				if human_built_trade > 2 or human_hand_trade > 1:
					score += 2
				if human_built_religious > 2 or human_hand_religious > 1:
					score += 2
				if human_built_military > 2 or human_hand_military > 1:
					score += 2
			"Thief":
				score += human_gold * 0.8
				if human_gold > 3:
					score += 5
				if human_gold > ai_gold:
					score += 2
				score += human_hand_high_cost * 1.5
			"Magician", "Wizard":
				if ai_hand.size() < 2:
					score += 10
				if human_hand.size() > 3:
					score += 7
				score += human_hand_high_cost * 2
				score += human_hand_trade
				score += human_hand_noble
				score += human_hand_religious
				score += human_hand_military
			"King":
				if not crown_holder.is_computer:
					score += 17
				else:
					score -= 6
				score += ai_built_noble * 3
				score += ai_hand_noble * 2
				score += human_built_noble * 2
			"Bishop":
				score += ai_built_religious * 3
				score += ai_hand_religious * 2
				if human_built_military > 1 or human_hand_military > 1:
					score += 4 # Defensive if human has military
			"Merchant":
				score += ai_gold * 0.6
				score += ai_built_trade * 3
				score += ai_hand_trade * 2
				if ai_hand.size() > 2:
					score += 3
				score += human_hand_trade
				score += human_built_trade
			"Architect":
				score += ai_hand.size() * 0.8
				if ai_hand.size() < 3:
					score += 10
				if ai_gold > 4:
					score += 4
				for d in ai_hand:
					if d:
						score += d.cost * 0.2
				if human_hand.size() > 3:
					score += 2
			"Warlord":
				score += 7
				score += ai_built_military * 2
				score += ai_hand_military
				for d in human_built:
					if d.cost >= 4:
						score += 4
					if d.is_purple_foil:
						score += 2
				if ai_gold > 2:
					score += 3
				score += human_built_high_cost * 2
				score += human_unique_built * 2
				score += human_built_military
			_:
				score += 2

		# Slightly prefer characters not discarded or face down
		#if character in discarded_characters:
		#	score -= 10
		#if character == face_down_character:
		#	score -= 10

		if score > best_score:
			best_score = score
			best_character = character

	if best_score <= 0:
		return choose_character_basic()
	return best_character

# --- Helper functions to be called by your game manager ---

func set_available_characters(cards: Array[CharacterData]):
	available_character_cards = cards


func set_player_states(ai_state: Player, human_state: Player):
	ai_player_state = ai_state
	ai_buildings = ai_player_state.district_cards_in_play
	human_player_state = human_state
	player_buildings = human_player_state.district_cards_in_play


func set_game_state(player_order: Array[Player], _crown_holder: Player, _round: int):
	player_turn_order = player_order
	crown_holder = _crown_holder
	round_number = _round
