class_name TestGame
extends Node3D


@export var duplicate_cards = 1

@onready var player_deck_collection = $PlayerDragController/DeckCardCollection
@onready var player_hand_collection = $PlayerDragController/HandCardCollection
@onready var opponent_deck_collection = $OpponentDragController/DeckCardCollection
@onready var opponent_hand_collection = $OpponentDragController/HandCardCollection
@onready var character_deck_collection = $CharacterDragController/CharacterDeckCollection
@onready var character_drawn_collection = $CharacterDragController/CharacterDrawnCollection
@onready var out_of_play_character_collection = $CharacterDragController/OutOfPlayCharacterCollection


@export var district_resources : Array[DistrictData]
@export var character_resources : Array[CharacterData]


func _ready() -> void:
	GameEvents.done_drawing_initial_character_cards.connect(_on_done_drawing_initial_character_cards)
	GameEvents.requested_draw_character_card.connect(_on_requested_draw_character_card)
	GameEvents.ready_to_exclude_characters.connect(_on_ready_to_exclude_characters)
	GameEvents.requested_player_draw_district_cards.connect(_on_requested_player_draw_district_cards)
	
	var player_deck : Array[NewCard3D]
	var opponent_deck : Array[NewCard3D]
	var character_deck : Array[NewCard3D]
	
	for card_id in district_resources:
		for duplicate_card in duplicate_cards:
			GameData.player_current_district_deck_build.push_back(card_id)
			player_deck.push_back(instantiate_district_card(card_id.district_name))
			opponent_deck.push_back(instantiate_district_card(card_id.district_name))
	
	for card_id in character_resources:
		character_deck.push_back(instantiate_character_card(card_id.character_name))

	player_deck.shuffle()
	opponent_deck.shuffle()
	character_deck.shuffle()
	
	for card in player_deck:
		card.face_down = true
		player_deck_collection.append_card(card)
		
	for card in opponent_deck:
		card.face_down = true
		opponent_deck_collection.append_card(card)
		
	for card in character_deck:
		card.face_down = true
		character_deck_collection.append_card(card)


func instantiate_district_card(id : String) -> NewCard3D:
	var scene = load("res://scenes/new_card_3d/new_card_3d.tscn")
	var test_card: NewCard3D = scene.instantiate()
	var card_data : Dictionary

	
	for district_card in district_resources:
		if district_card.district_name == id:
			card_data = {
				"id" : id,
				"front_material": district_card.front_material,
				"back_material": district_card.back_material,
				"coin_cost": district_card.cost
			}
	test_card.data = card_data
	
	return test_card


func instantiate_character_card(id : String) -> NewCard3D:
	var scene = load("res://scenes/new_card_3d/new_card_3d.tscn")
	var test_card: NewCard3D = scene.instantiate()
	var card_data : Dictionary

	
	for character_card in character_resources:
		if character_card.character_name == id:
			card_data = {
				"id" : id,
				"front_material": character_card.front_material,
				"back_material": character_card.back_material,
			}
	test_card.data = card_data
	
	return test_card

# clicking on deck adds card to hand
func _on_deck_card_collection_card_clicked(_card: Variant) -> void:
	player_draw_card()


func _on_opponent_deck_card_collection_card_clicked(card: Variant) -> void:
	opponent_draw_card()


func player_draw_card() -> void:
	var cards = player_deck_collection.cards
	var card_global_position = cards[cards.size() - 1].global_position
	var drawn_card = player_deck_collection.remove_card(cards.size() - 1)
	(drawn_card as NewCard3D).face_down = false
	player_hand_collection.append_card(drawn_card)
	drawn_card.global_position = card_global_position

	if cards.size() == 0:
		#await(get_tree().create_timer(.1), "timeout")
		var timer = get_tree().create_timer(.1)
		await timer.timeout
		$PlayerDragController/EmptyDeck.visible = true


func opponent_draw_card() -> void:
	var cards = opponent_deck_collection.cards
	var card_global_position = cards[cards.size() - 1].global_position
	var drawn_card = opponent_deck_collection.remove_card(cards.size() - 1)
	(drawn_card as NewCard3D).face_down = true
	opponent_hand_collection.append_card(drawn_card)
	drawn_card.global_position = card_global_position

	if cards.size() == 0:
		#await(get_tree().create_timer(.1), "timeout")
		var timer = get_tree().create_timer(.1)
		await timer.timeout
		$OpponentDragController/OpponentEmptyDeck.visible = true


func _on_requested_player_draw_district_cards(player : Player, count : int) -> void:
	if player.is_computer:
		for i in count:
			await get_tree().create_timer(0.05).timeout
			opponent_draw_card()
	if not player.is_computer:
		for i in count:
			await get_tree().create_timer(0.05).timeout
			player_draw_card()


func _on_ready_to_exclude_characters() -> void:
	pass


func _on_requested_draw_character_card(face_down : bool) -> void:
	var cards = character_deck_collection.cards
	var card_global_position = cards[cards.size() - 1].global_position
	var drawn_card = character_deck_collection.remove_card(cards.size() - 1)
	(drawn_card as NewCard3D).face_down = face_down
	character_drawn_collection.append_card(drawn_card)
	drawn_card.global_position = card_global_position


func _on_done_drawing_initial_character_cards() -> void:
	$HUD/AcceptButton.show()


func _on_accept_button_pressed() -> void:
	GameEvents.accepted_character_cards.emit()
	
	var cards : Array = character_drawn_collection.cards
	cards.reverse()

	for c in 5:
		var card_global_position = cards[cards.size() - 1].global_position
		var drawn_card = character_drawn_collection.remove_card(cards.size() - 1)
		#(drawn_card as NewCard3D).face_down = face_down
		out_of_play_character_collection.append_card(drawn_card)
		drawn_card.global_position = card_global_position
