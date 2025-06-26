class_name ExcludeCharactersState
extends State

var excluded_cards_accepted : bool = false

@export var select_character_state : State


func enter() -> void:
	print('exclude characters state')
	GameEvents.accepted_character_cards.connect(_on_accepted_character_cards)
	GameEvents.starting_excluded_characters_state.emit()
	GameEvents.requested_show_in_battle_character_card_handler_overlay.emit()
	draw_excluded_character_cards()


func exit() -> void:
	GameEvents.accepted_character_cards.disconnect(_on_accepted_character_cards)


func process_frame(_delta : float) -> State:
	if excluded_cards_accepted:
		return select_character_state
	else:
		return null


func draw_excluded_character_cards() -> void:
	GameEvents.requested_draw_character_card.emit(true)
	
	await get_tree().create_timer(0.05).timeout
	
	for i in 4:
		GameEvents.requested_draw_character_card.emit(false)
		await get_tree().create_timer(0.05).timeout
		
	GameEvents.done_drawing_initial_character_cards.emit()


func _on_accepted_character_cards() -> void:
	excluded_cards_accepted = true
