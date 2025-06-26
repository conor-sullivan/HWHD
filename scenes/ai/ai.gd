class_name AI
extends Node

###############################################################

#Explanation:
#
	#Enums: Difficulty enum defines the different AI difficulty levels.
	#Export Variables: @export allows you to set the AI's difficulty and name in the Godot editor.
	#Game State Information: These variables hold the necessary information about the game's state. Your game manager node would update these before the AI makes a choice.
		#available_character_cards: The list of character cards the AI can choose from in the current round.
		#ai_player_state and human_player_state: Dictionaries containing relevant information about each player (gold, hand, etc.). You'll need to define the structure of these dictionaries based on your game's needs.
		#player_turn_order, crown_holder, discarded_characters, face_down_character, round_number: These variables provide context about the current round and game state.
		#player_buildings: A dictionary mapping player names to arrays of their built district cards. This is important for the Warlord's ability in the Advanced AI.
	#choose_character(): This function is the main entry point for the AI's decision-making. It calls the appropriate function based on the selected difficulty.
	#choose_character_basic(): Implements the basic AI by simply returning a random character from the available list.
	#choose_character_intermediate():
		#Iterates through the available characters.
		#Assigns a "score" to each character based on intermediate-level factors:
			#How much gold and district cards the AI has.
			#How much gold and district cards the human player has.
			#Whether the King character is available (and who holds the Crown).
		#Selects the character with the highest calculated score.
		#Includes a fallback to the basic AI if all characters result in a negative score (indicating no particularly advantageous choice).
	#choose_character_advanced():
		#Builds upon the intermediate logic.
		#Includes additional factors for a better decision:
			#The specific district cards in the AI's hand and the human player's hand.
			#The built districts of both players (to evaluate the potential effectiveness of the Warlord's ability).
			#(Optional but recommended for truly advanced AI) More complex character targeting logic (e.g., predicting the human's choice).
	#Helper Functions:
		#set_available_characters(), set_player_states(), set_game_state(): These functions are designed to be called by your game manager to update the AI's internal state with the latest game information before the AI needs to make a decision.
#
#How to Use:
#
	#Attach this script to an AI node in your Godot scene.
	#Set the difficulty and ai_name in the Inspector.
	#In your game manager script, when it's the AI's turn to choose a character, call the helper functions (set_available_characters, set_player_states, set_game_state) to update the AI's state.
	#Then, call the choose_character() function to get the AI's chosen character.
#
#Important Notes:
#
	#District Card Representation: You'll need to define how you represent district cards (e.g., as dictionaries with properties like "name," "cost," "type"). The example code uses placeholders like district_card["cost"] and district_card["type"].
	#Scoring System: The scoring system in the intermediate and advanced AI is a starting point. You'll need to fine-tune the values (e.g., the multipliers like 0.5, 0.7, etc.) to balance the AI's behavior and make it challenging but fair.
	#Character Abilities: You'll need to implement the actual logic for using character abilities in your game manager based on the chosen character. This AI script is only for choosing the character.
	#Refinement: The advanced AI can be made even more sophisticated by incorporating things like:
		#Predicting the human player's likely character choices based on their previous actions and game state.
		#Considering the order of character ranks when evaluating potential benefits and risks.
		#Implementing a more complex evaluation function that takes into account the cumulative effect of a character's ability throughout the round.
		#Using machine learning techniques if you want to explore more complex AI behaviors, but that would be a significant undertaking.
#
###############################################################


enum Difficulty { BASIC, INTERMEDIATE, ADVANCED }

# --- Export Variables ---
@export var difficulty: Difficulty = Difficulty.BASIC
@export var ai_name: String = "AI Player"

# --- Game State Information (These would be passed from your game manager) ---
var available_character_cards: Array  # Array of available Character card IDs/names
var ai_player_state: Dictionary       # Player's current gold, hand, etc.
var human_player_state: Dictionary    # Human player's current gold, hand, etc.
var player_turn_order: Array        # Current player order (important for who gets the Crown)
var crown_holder: String            # Name of the player holding the Crown
var discarded_characters: Array     # Characters discarded this round
var face_down_character: String     # The character put face down (for 2-player rules)
var round_number: int               # Current round number (for potential strategic changes)
var player_buildings: Dictionary    # Dictionary mapping player names to their built districts (Array of district cards)

# --- AI Logic ---
func choose_character():
	match difficulty:
		Difficulty.BASIC:
			return choose_character_basic()
		Difficulty.INTERMEDIATE:
			return choose_character_intermediate()
		Difficulty.ADVANCED:
			return choose_character_advanced()

# Basic AI: Randomly choose a character
func choose_character_basic():
	if available_character_cards.is_empty():
		return null # No characters left
	var chosen_character = available_character_cards[randi() % available_character_cards.size()]
	return chosen_character

# Intermediate AI: Considers gold, hand size, and player turn order
func choose_character_intermediate():
	if available_character_cards.is_empty():
		return null

	var best_character = null
	var best_score = -1000 # Initialize with a low score

	for character in available_character_cards:
		var current_score = 0

		# --- Evaluate based on current resources ---
		# Prioritize characters that provide needed resources or actions
		if character == "Merchant": # Example: Gives gold
			current_score += ai_player_state["gold"] * 0.5  # Value extra gold based on current wealth
		elif character == "Architect": # Example: Allows building more
			current_score += ai_player_state["district_cards_in_hand"].size() * 0.7 # Value being able to build many districts
		elif character == "Thief": # Example: Steals gold
			current_score += human_player_state["gold"] * 0.6 # Value stealing from the opponent

		# --- Evaluate based on opponent's resources ---
		if character == "Assassin": # Example: Targets opponent's character
			# Could add a bonus for targeting characters the human player might want (e.g., King, high-income character)
			current_score += 10 # Base value for the Assassin
		elif character == "Warlord": # Example: Destroys opponent's buildings
			# Value destroying an opponent's high-value building
			current_score += 5 # Base value for the Warlord

		# --- Evaluate based on player turn order (who has the Crown) ---
		if character == "King" and crown_holder != ai_name:
			current_score += 15 # High value for getting the Crown
		elif character == "King" and crown_holder == ai_name:
			current_score -= 5 # Lower value if already King (might be targeted)

		# Consider hand size: characters that help draw cards (e.g., Architect) could be useful if hand is small
		if character == "Architect" and ai_player_state["district_cards_in_hand"].size() < 3:
			current_score += 8

		# --- Update best character if the current character has a higher score ---
		if current_score > best_score:
			best_score = current_score
			best_character = character

	# If no character has a positive score (e.g., all remaining are unfavorable), choose randomly
	if best_score <= 0:
		return choose_character_basic()

	return best_character

# Advanced AI: Incorporates all intermediate factors, plus considers specific district cards
func choose_character_advanced():
	if available_character_cards.is_empty():
		return null

	var best_character = null
	var best_score = -1000 # Initialize with a low score

	for character in available_character_cards:
		var current_score = 0

		# --- Intermediate AI logic (copy from intermediate function) ---
		# --- Evaluate based on current resources ---
		if character == "Merchant": # Example: Gives gold
			current_score += ai_player_state["gold"] * 0.5
		elif character == "Architect": # Example: Allows building more
			current_score += ai_player_state["district_cards_in_hand"].size() * 0.7
		elif character == "Thief": # Example: Steals gold
			current_score += human_player_state["gold"] * 0.6

		# --- Evaluate based on opponent's resources ---
		if character == "Assassin":
			# Could add more complex targeting logic here based on opponent's likely character
			current_score += 10
		elif character == "Warlord":
			# Consider value of destroying opponent's specific built districts
			current_score += 5

		# --- Evaluate based on player turn order (who has the Crown) ---
		if character == "King" and crown_holder != ai_name:
			current_score += 15
		elif character == "King" and crown_holder == ai_name:
			current_score -= 5

		if character == "Architect" and ai_player_state["district_cards_in_hand"].size() < 3:
			current_score += 8

		# --- Advanced AI logic (considering specific district cards) ---
		# Evaluate how well the character's ability synergizes with the AI's hand
		for district_card in ai_player_state["district_cards_in_hand"]:
			if character == "Architect": # Build more districts
				current_score += district_card["cost"] * 0.2  # Value being able to build higher-cost districts
			elif character == "Merchant" and district_card["type"] == "Trade": # Income from Trade districts
				current_score += 2 # Bonus for having Trade districts as Merchant

		# Evaluate how the character's ability can counter the human player's hand or built districts
		for district_card in human_player_state["district_cards_in_hand"]:
			# Example: As Wizard, potentially steal a high-cost district from the human's hand
			if character == "Wizard":
				current_score += district_card["cost"] * 0.3

		for district_card in human_player_state["built_districts"]:
			 # Example: As Warlord, potentially destroy a high-value district
			if character == "Warlord":
				current_score += district_card["cost"] * 0.4

		# Consider potential character targets (more complex):
		# The AI could try to predict which character the human player is likely to choose based on their situation
		# and then target that character with the Assassin or Thief.

		# --- Update best character if the current character has a higher score ---
		if current_score > best_score:
			best_score = current_score
			best_character = character

	# If no character has a positive score (e.g., all remaining are unfavorable), choose randomly
	if best_score <= 0:
		return choose_character_basic()

	return best_character

# --- Helper functions to be called by your game manager ---

func set_available_characters(cards: Array):
	available_character_cards = cards

func set_player_states(ai_state: Dictionary, human_state: Dictionary):
	ai_player_state = ai_state
	human_player_state = human_state

func set_game_state(player_order: Array, crown: String, discarded: Array, face_down: String, _round: int, built_districts: Dictionary):
	player_turn_order = player_order
	crown_holder = crown
	discarded_characters = discarded
	face_down_character = face_down
	round_number = _round
	player_buildings = built_districts
