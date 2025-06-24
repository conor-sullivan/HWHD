class_name SelectCharacterState
extends State

@export var take_turn_state : State

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


func exit() -> void:
	GameEvents.all_character_cards_chosen.emit()
	GameEvents.character_choices_provided.disconnect(_on_character_choices_provided)


func process_frame(_delta : float) -> State:
	if character_selection_done:
		return take_turn_state
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
		elif player.is_computer:
			if not player.current_character_card:
				character_choices.shuffle()
				player.current_character_card = character_choices[0]
	
	character_selection_done = true
	


func _on_character_choices_provided(characters : Array[CharacterData]) -> void:
	character_choices = characters


func draw_available_character_cards() -> void:
	for i in number_of_cards:
		GameEvents.requested_draw_character_card.emit(false)
		await get_tree().create_timer(0.05).timeout
	GameEvents.done_drawing_available_character_cards.emit()
