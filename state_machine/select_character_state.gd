class_name SelectCharacterState
extends State

@export var initialize_turn_state : State

var character_selection_done : bool = false
var number_of_cards : int
var character_choices : Array[CharacterData]


func enter() -> void:
	print("select character state")
	character_choices = []
	GameEvents.character_choices_provided.connect(_on_character_choices_provided)
	GameEvents.players_character_card_selected.connect(_on_players_character_card_selected)
	GameEvents.opponents_character_card_selected.connect(_on_opponents_character_card_selected)
	
	if GameData.current_battle.real_player.is_king:
		number_of_cards = 3
	else:
		number_of_cards = 2
	GameEvents.starting_select_character_state.emit(number_of_cards)
	draw_available_character_cards()


func ai_pick_character() -> CharacterData:
	var ai = AI.new()
	ai.set_available_characters()
	ai.set_game_state()
	ai.set_player_states()
	ai.difficulty = ai.Difficulty.BASIC
	ai.choose_character()


func exit() -> void:
	GameEvents.all_character_cards_chosen.emit()
	GameEvents.character_choices_provided.disconnect(_on_character_choices_provided)


func process_frame(_delta : float) -> State:
	if character_selection_done:
		return initialize_turn_state
	else:
		return null


func _on_opponents_character_card_selected(chosen_character : CharacterData) -> void:
	for player in GameData.current_battle.players:
		if player.is_computer:
			player.current_character_card = chosen_character


func _on_players_character_card_selected(chosen_character : CharacterData) -> void:
	character_choices.erase(chosen_character)
	for player in GameData.current_battle.players:
		if not player.is_computer:
			player.current_character_card = chosen_character
			player.possible_character_targets = character_choices
		elif player.is_computer:
			if not player.current_character_card:
				character_choices.shuffle()
				player.current_character_card = character_choices[0]
				player.possible_character_targets.erase(player.current_character_card)
				# update 
				for character in character_choices:
					player.possible_character_targets.erase(character)
				for character in player.known_excluded_characters:
					player.possible_character_targets.erase(character)
	
	character_selection_done = true
	

func update_possible_character_targets_in_player_data() -> void:
	pass



func _on_character_choices_provided(characters : Array[CharacterData]) -> void:
	character_choices = characters
	for c in character_choices:
		print(c.character_name)


func draw_available_character_cards() -> void:
	for i in number_of_cards:
		GameEvents.requested_draw_character_card.emit(false)
		await get_tree().create_timer(0.05).timeout
	GameEvents.done_drawing_available_character_cards.emit()
