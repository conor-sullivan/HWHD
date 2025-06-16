class_name ExcludeCharactersState
extends State


func enter() -> void:
	print('exclude characters state')
	GameEvents.accepted_character_cards.connect(_on_accepted_character_cards)
	draw_initial_character_cards()


func exit() -> void:
	GameEvents.accepted_character_cards.disconnect(_on_accepted_character_cards)


func draw_initial_character_cards() -> void:
	GameEvents.requested_draw_character_card.emit(true)
	await get_tree().create_timer(0.1).timeout
	for i in 4:
		GameEvents.requested_draw_character_card.emit(false)
		await get_tree().create_timer(0.1).timeout
	GameEvents.done_drawing_initial_character_cards.emit()


func _on_accepted_character_cards() -> void:
	pass


# move 5 cards from the deck to the drawn collection, fist 1 face down

# show accept button
# once accepted, move all cards from the drawn collection, to the out of play collection
# move all cards from the deck collection to the drawn collection
# if real player is king, flip face up, else keep face down
