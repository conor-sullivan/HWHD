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

func magician_ability_advanced() -> Dictionary:
	var ai_hand = ai_player_state.district_cards_in_hand
	var human_hand = human_player_state.district_cards_in_hand

	# Count unique/purple cards in both hands
	var ai_unique = 0
	var human_unique = 0
	for card in ai_hand:
		if card.is_purple_foil:
			ai_unique += 1
	for card in human_hand:
		if card.is_purple_foil:
			human_unique += 1

	# Exchange if human has more cards or more unique cards
	if human_hand.size() - ai_hand.size() >= 2 or human_unique > ai_unique:
		return { "action": "exchange", "cards_to_discard": [] }

	# Otherwise, discard low-importance cards
	var ai_gold = ai_player_state.gold_count
	var color_focus = get_ai_color_focus()
	var cards_to_discard : Array[DistrictData] = []
	for card in ai_hand:
		# Discard if too expensive, not matching color focus, or duplicate
		var is_duplicate = ai_hand.count(card) > 1
		var not_focus = color_focus != "" and card.color != color_focus
		if card.cost > ai_gold or is_duplicate or not_focus:
			cards_to_discard.append(card)
	return { "action": "discard_draw", "cards_to_discard": cards_to_discard }

func magician_ability_intermediate() -> Dictionary:
	var ai_hand = ai_player_state.district_cards_in_hand
	var human_hand = human_player_state.district_cards_in_hand
	if human_hand.size() - ai_hand.size() >= 2:
		return { "action": "exchange", "cards_to_discard": [] }
	else:
		var ai_gold = ai_player_state.gold_count
		var cards_to_discard : Array[DistrictData] = []
		for card in ai_hand:
			if card.cost > ai_gold:
				cards_to_discard.append(card)
		# If nothing to discard, discard nothing
		return { "action": "discard_draw", "cards_to_discard": cards_to_discard }

func magician_ability_basic() -> Dictionary:
	var action = ["exchange", "discard_draw"].pick_random()
	if action == "exchange":
		return { "action": "exchange", "cards_to_discard": [] }
	else:
		var hand = ai_player_state.district_cards_in_hand.duplicate()
		var num_to_discard = randi_range(1, hand.size())
		hand.shuffle()
		var cards_to_discard : Array[DistrictData] = hand.slice(0, num_to_discard)
		return { "action": "discard_draw", "cards_to_discard": cards_to_discard }

func use_magician_ability() -> Dictionary:
	# Returns a dictionary with { "action": "exchange" or "discard_draw", "cards_to_discard": Array }
	match difficulty:
		Difficulty.BASIC:
			return magician_ability_basic()
		Difficulty.INTERMEDIATE:
			return magician_ability_intermediate()
		Difficulty.ADVANCED:
			return magician_ability_advanced()
	
	return {}

# Helper to determine AI's color focus (most built color)
func get_ai_color_focus() -> String:
	var color_counts = { "Gold": 0, "Blue": 0, "Green": 0, "Red": 0 }
	for d in ai_player_state.district_cards_in_play:
		if d.color in color_counts:
			color_counts[d.color] += 1
	var max_color = ""
	var max_count = 0
	for color in color_counts.keys():
		if color_counts[color] > max_count:
			max_count = color_counts[color]
			max_color = color
	return max_color

# BASIC: Play a random card the AI can afford
func choose_district_card_to_play_basic() -> DistrictData:
	var affordable = []
	var gold = ai_player_state.gold_count
	for card in ai_player_state.district_cards_in_hand:
		if card.cost <= gold and not ai_player_state.district_cards_in_play.has(card):
			affordable.append(card)
	if affordable.is_empty():
		return null
	return affordable[randi() % affordable.size()]

# INTERMEDIATE: Prefer cards that match AI's color focus or are unique, and can be afforded
func choose_district_card_to_play_intermediate() -> DistrictData:
	var gold = ai_player_state.gold_count
	var color_focus = get_ai_color_focus()
	var best_card = null
	var best_score = -1000
	for card in ai_player_state.district_cards_in_hand:
		if card.cost > gold or ai_player_state.district_cards_in_play.has(card):
			continue
		var score = 0
		if card.color == color_focus:
			score += 5
		if card.is_purple_foil:
			score += 4
		score += 10 - card.cost # Prefer cheaper cards if all else equal
		if score > best_score:
			best_score = score
			best_card = card
	return best_card

# ADVANCED: Evaluate based on color focus, uniqueness, cost, and synergy with built districts
func choose_district_card_to_play_advanced() -> DistrictData:
	var gold = ai_player_state.gold_count
	var color_focus = get_ai_color_focus()
	var built_colors = []
	for d in ai_player_state.district_cards_in_play:
		built_colors.append(d.color)
	var best_card = null
	var best_score = -1000
	for card in ai_player_state.district_cards_in_hand:
		if card.cost > gold or ai_player_state.district_cards_in_play.has(card):
			continue
		var score = 0
		if card.color == color_focus:
			score += 6
		if card.is_purple_foil:
			score += 5
		if not built_colors.has(card.color):
			score += 3 # Diversity bonus
		score += 12 - card.cost # Prefer cheaper cards
		if ai_player_state.district_cards_in_play.count(card) > 0:
			score -= 10 # Avoid duplicates
		if score > best_score:
			best_score = score
			best_card = card
	return best_card

# Main function to choose which card to play, based on difficulty
func choose_district_card_to_play() -> DistrictData:
	match difficulty:
		Difficulty.BASIC:
			return choose_district_card_to_play_basic()
		Difficulty.INTERMEDIATE:
			return choose_district_card_to_play_intermediate()
		Difficulty.ADVANCED:
			return choose_district_card_to_play_advanced()
	return null

# BASIC: Randomly guess from the possible character targets
func guess_opponent_character_basic() -> CharacterData:
	var possible = human_player_state.possible_character_targets
	if possible.is_empty():
		return null
	return possible[randi() % possible.size()]

# INTERMEDIATE: Guess based on the opponent's gold, hand size, and built districts
func guess_opponent_character_intermediate() -> CharacterData:
	var possible = human_player_state.possible_character_targets
	if possible.is_empty():
		return null
	var best_guess = null
	var best_score = -1000
	for character in possible:
		var score = 0
		match character.character_name:
			"King":
				if human_player_state.district_cards_in_play.count({ "color": "Gold" }) > 1:
					score += 3
			"Bishop":
				if human_player_state.district_cards_in_play.count({ "color": "Blue" }) > 1:
					score += 3
			"Merchant":
				if human_player_state.gold_count > 3:
					score += 2
				if human_player_state.district_cards_in_play.count({ "color": "Green" }) > 1:
					score += 2
			"Warlord":
				if human_player_state.district_cards_in_play.count({ "color": "Red" }) > 1:
					score += 3
			"Architect":
				if human_player_state.district_cards_in_hand.size() > 3:
					score += 2
			"Magician":
				if human_player_state.district_cards_in_hand.size() < 2:
					score += 2
			"Thief":
				if human_player_state.gold_count > 2:
					score += 2
			"Assassin":
				score += 1 # Always a possibility
			_:
				score += 0
		if score > best_score:
			best_score = score
			best_guess = character
	return best_guess

# ADVANCED: Use a scoring system similar to your character selection logic, but for the opponent
func guess_opponent_character_advanced() -> CharacterData:
	var possible = human_player_state.possible_character_targets
	if possible.is_empty():
		return null
	var best_guess = null
	var best_score = -1000
	for character in possible:
		var score = 0
		match character.character_name:
			"King":
				score += human_player_state.district_cards_in_play.count({ "color": "Gold" }) * 2
				if not crown_holder.is_computer:
					score += 2
			"Bishop":
				score += human_player_state.district_cards_in_play.count({ "color": "Blue" }) * 2
				if human_player_state.district_cards_in_play.count({ "color": "Red" }) > 1:
					score += 1 # Defensive pick
			"Merchant":
				score += human_player_state.gold_count
				score += human_player_state.district_cards_in_play.count({ "color": "Green" }) * 2
			"Warlord":
				score += human_player_state.district_cards_in_play.count({ "color": "Red" }) * 2
				if ai_player_state.district_cards_in_play.size() > 0:
					score += 1 # If AI has targets
			"Architect":
				score += human_player_state.district_cards_in_hand.size()
			"Magician":
				score += 2 if human_player_state.district_cards_in_hand.size() < 2 else 0
				score += 2 if ai_player_state.district_cards_in_hand.size() > 3 else 0
			"Thief":
				score += human_player_state.gold_count * 0.7
			"Assassin":
				score += 1
			_:
				score += 0
		if score > best_score:
			best_score = score
			best_guess = character
	return best_guess


func choose_gain_gold_or_card() -> String:
	match difficulty:
		Difficulty.BASIC:
			# Random choice for basic AI
			return ["gold", "card"].pick_random()
		Difficulty.INTERMEDIATE:
			# Prefer gold if can't afford to build, otherwise prefer card if hand is small
			var affordable = false
			for card in ai_player_state.district_cards_in_hand:
				if card.cost <= ai_player_state.gold_count and not ai_player_state.district_cards_in_play.has(card):
					affordable = true
					break
			if not affordable:
				return "gold"
			elif ai_player_state.district_cards_in_hand.size() < 2:
				return "card"
			else:
				return "gold"
		Difficulty.ADVANCED:
			# Advanced: prefer gold if can't build, prefer card if hand is empty or all cards are expensive, else weigh options
			var can_build = false
			var cheapest = 999
			for card in ai_player_state.district_cards_in_hand:
				if card.cost <= ai_player_state.gold_count and not ai_player_state.district_cards_in_play.has(card):
					can_build = true
				if card.cost < cheapest:
					cheapest = card.cost
			if not can_build:
				return "gold"
			elif ai_player_state.district_cards_in_hand.is_empty():
				return "card"
			elif ai_player_state.gold_count > cheapest + 2:
				return "card"
			else:
				return "gold"
	return "gold"


func choose_between_two_district_cards(card_a: DistrictData, card_b: DistrictData) -> DistrictData:
	match difficulty:
		Difficulty.BASIC:
			# Random choice
			return [card_a, card_b].pick_random()
		Difficulty.INTERMEDIATE:
			# Prefer the card that matches AI's color focus, otherwise cheaper card
			var color_focus = get_ai_color_focus()
			var a_score = 0
			var b_score = 0
			if card_a.color == color_focus:
				a_score += 2
			if card_b.color == color_focus:
				b_score += 2
			a_score += 10 - card_a.cost
			b_score += 10 - card_b.cost
			return card_a if a_score >= b_score else card_b
		Difficulty.ADVANCED:
			# Prefer unique, color focus, and synergy; avoid duplicates and high cost
			var color_focus = get_ai_color_focus()
			var built_colors = []
			for d in ai_player_state.district_cards_in_play:
				built_colors.append(d.color)
			var a_score = 0
			var b_score = 0
			if card_a.color == color_focus:
				a_score += 3
			if card_b.color == color_focus:
				b_score += 3
			if not built_colors.has(card_a.color):
				a_score += 2
			if not built_colors.has(card_b.color):
				b_score += 2
			if card_a.is_purple_foil:
				a_score += 2
			if card_b.is_purple_foil:
				b_score += 2
			a_score += 12 - card_a.cost
			b_score += 12 - card_b.cost
			if ai_player_state.district_cards_in_hand.has(card_a):
				a_score -= 5 # Avoid duplicates
			if ai_player_state.district_cards_in_hand.has(card_b):
				b_score -= 5
			return card_a if a_score >= b_score else card_b
	return card_a



func choose_warlord_target() -> DistrictData:
	match difficulty:
		Difficulty.BASIC:
			# Pick a random valid target from the opponent's districts that can be destroyed
			var possible_targets = []
			for d in human_player_state.district_cards_in_play:
				if d.cost > 1 and d.cost - 1 <= ai_player_state.gold_count and not d.is_protected:
					possible_targets.append(d)
			if possible_targets.is_empty():
				return null
			return possible_targets[randi() % possible_targets.size()]
		Difficulty.INTERMEDIATE:
			# Prefer highest cost district the AI can afford to destroy
			var best_target = null
			var best_cost = -1
			for d in human_player_state.district_cards_in_play:
				if d.cost > 1 and d.cost - 1 <= ai_player_state.gold_count and not d.is_protected:
					if d.cost > best_cost:
						best_cost = d.cost
						best_target = d
			return best_target
		Difficulty.ADVANCED:
			# Prefer unique (purple) or high-value districts, avoid duplicates, and consider color strategy
			var best_target = null
			var best_score = -1000
			for d in human_player_state.district_cards_in_play:
				if d.cost > 1 and d.cost - 1 <= ai_player_state.gold_count and not d.is_protected:
					var score = d.cost * 2
					if d.is_purple_foil:
						score += 5
					# Penalize if opponent has duplicates (less valuable to destroy)
					if human_player_state.district_cards_in_play.count(d) > 1:
						score -= 3
					# Bonus if district matches opponent's color focus
					var opp_color_focus = ""
					var color_counts = { "Gold": 0, "Blue": 0, "Green": 0, "Red": 0 }
					for dd in human_player_state.district_cards_in_play:
						if dd.color in color_counts:
							color_counts[dd.color] += 1
					var max_count = 0
					for color in color_counts.keys():
						if color_counts[color] > max_count:
							max_count = color_counts[color]
							opp_color_focus = color
					if d.color == opp_color_focus:
						score += 3
					if score > best_score:
						best_score = score
						best_target = d
			return best_target
	return null