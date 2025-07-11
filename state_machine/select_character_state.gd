class_name SelectCharacterState
extends State

@export var initialize_turn_state : State

var character_selection_done : bool = false
var number_of_cards : int
var character_choices : Array[CharacterData]
var original_character_choices : Array[CharacterData]


func enter() -> void:
	print("select character state")
	
	character_selection_done = false
	character_choices = []
	original_character_choices = []
	
	GameEvents.character_choices_provided.connect(_on_character_choices_provided)
	GameEvents.players_character_card_selected.connect(_on_players_character_card_selected)
	GameEvents.opponents_character_card_selected.connect(_on_opponents_character_card_selected)
	
	if GameData.current_battle.real_player.is_king:
		number_of_cards = 3
	else:
		number_of_cards = 2

	if GameData.current_battle.opponent_player.is_king:
		opponent_pick_character(GameData.current_battle.character_cards)

	GameEvents.starting_select_character_state.emit(number_of_cards)
	draw_available_character_cards()


func opponent_pick_character(_choices : Array[CharacterData]) -> void:
	var opponent_character = ai_pick_character(_choices)
	GameData.current_battle.character_cards.erase(opponent_character)
	var unselected_characters = _choices 

	unselected_characters.erase(opponent_character)

	GameData.current_battle.opponent_player.current_character_card = opponent_character
	GameData.current_battle.opponent_player.unselected_characters = unselected_characters

	character_choices.erase(opponent_character)

	_on_opponents_character_card_selected(opponent_character)


func ai_pick_character(_choices : Array[CharacterData]) -> CharacterData:
	var ai = AI.new()
	var ai_player = GameData.current_battle.opponent_player
	var player = GameData.current_battle.real_player
	
	var crown_holder : Player
	var player_order : Array[Player]
	
	if ai_player.is_king:
		crown_holder = ai_player
		player_order.append(ai_player)
		player_order.append(player)
	else:
		crown_holder = player
		player_order.append(player)
		player_order.append(ai_player)
		
		
	ai.set_available_characters(_choices)
	ai.set_player_states(ai_player, player)
	ai.set_game_state(player_order, crown_holder, GameData.current_battle.round_number)
	
	ai.difficulty = GameData.current_battle.difficulty 
	
	var result = ai.choose_character()
	print(result.character_name)
	return result


func exit() -> void:
	GameEvents.all_character_cards_chosen.emit()
	GameEvents.character_choices_provided.disconnect(_on_character_choices_provided)
	GameEvents.players_character_card_selected.disconnect(_on_players_character_card_selected)
	GameEvents.opponents_character_card_selected.disconnect(_on_opponents_character_card_selected)

func process_frame(_delta : float) -> State:
	if character_selection_done:
		return initialize_turn_state
	else:
		return null


func _on_opponents_character_card_selected(chosen_character : CharacterData) -> void:
	GameData.current_battle.opponent_player.current_character_card = chosen_character
	update_possible_character_targets(GameData.current_battle.opponent_player)


func _on_players_character_card_selected(chosen_character : CharacterData) -> void:
	GameData.current_battle.real_player.current_character_card = chosen_character
	character_choices.erase(chosen_character)
	var unselected_characters = original_character_choices.duplicate()
	unselected_characters.erase(chosen_character)
	for c in original_character_choices:
		print('origional: ', c.character_name)
	for c in unselected_characters:
		print('unselected: ', c.character_name)
		GameData.current_battle.real_player.unselected_characters += [c]
	update_possible_character_targets(GameData.current_battle.real_player)

	if not GameData.current_battle.opponent_player.is_king:
		opponent_pick_character(GameData.current_battle.real_player.unselected_characters)
	
	character_selection_done = true


func update_possible_character_targets(player : Player) -> void:
	if player.is_king:
		player.possible_character_targets = player.unselected_characters.duplicate()
	else:
		var characters = GameData.current_battle.original_character_cards.duplicate() 
		for c in player.unselected_characters:
				characters.erase(c)
		for c in player.known_excluded_characters:
			characters.erase(c)
		characters.erase(player.current_character_card)
		player.possible_character_targets = characters


func _on_character_choices_provided(characters : Array[CharacterData]) -> void:
	original_character_choices = characters.duplicate() # Store the original 3


func draw_available_character_cards() -> void:
	for i in number_of_cards:
		GameEvents.requested_draw_character_card.emit(false)
		await get_tree().create_timer(0.05).timeout
	GameEvents.done_drawing_available_character_cards.emit()
