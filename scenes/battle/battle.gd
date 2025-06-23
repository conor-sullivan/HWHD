class_name Battle
extends Node3D


@export var duplicate_cards = 1

@onready var player_deck_collection = $PlayerDragController/DeckCardCollection
@onready var player_hand_collection = $PlayerDragController/HandCardCollection
@onready var opponent_deck_collection = $OpponentDragController/DeckCardCollection
@onready var opponent_hand_collection = $OpponentDragController/HandCardCollection


@export var district_resources : Array[DistrictData]


func _ready() -> void:
	GameEvents.done_drawing_initial_character_cards.connect(_on_done_drawing_initial_character_cards)
	GameEvents.ready_to_exclude_characters.connect(_on_ready_to_exclude_characters)
	GameEvents.requested_player_draw_district_cards.connect(_on_requested_player_draw_district_cards)
	
	var player_deck : Array[NewCard3D]
	var opponent_deck : Array[NewCard3D]
	var character_deck : Array[NewCard3D]
	
	for card_id in district_resources:
		for duplicate_card in duplicate_cards:
			GameData.player_current_district_deck_build.push_back(card_id)
			var player_card = instantiate_district_card(card_id.district_name)
			player_card.is_real_players = true
			player_deck.push_back(player_card)
			opponent_deck.push_back(instantiate_district_card(card_id.district_name))

	player_deck.shuffle()
	opponent_deck.shuffle()
	character_deck.shuffle()
	
	for card in player_deck:
		card.face_down = true
		player_deck_collection.append_card(card)
		
	for card in opponent_deck:
		card.face_down = true
		opponent_deck_collection.append_card(card)
	


func instantiate_district_card(id : String) -> NewCard3D:
	var scene = load("res://scenes/new_card_3d/new_card_3d.tscn")
	var test_card: NewCard3D = scene.instantiate()
	var card_data : Dictionary

	
	for district_card in district_resources:
		if district_card.district_name == id:
			test_card.resource = district_card
			card_data = {
				"id" : id,
				"front_material": district_card.front_material,
				"back_material": district_card.back_material,
				"coin_cost": district_card.cost,
				'sprite_texture' : district_card.sprite_texture
			}
	test_card.data = card_data
	
	
	return test_card


# clicking on deck adds card to hand
func _on_deck_card_collection_card_clicked(_card: Variant) -> void:
	player_draw_card()


func _on_opponent_deck_card_collection_card_clicked(_card: Variant) -> void:
	opponent_draw_card()


func player_draw_card() -> void:
	var cards = player_deck_collection.cards
	var card_global_position = cards[cards.size() - 1].global_position
	var drawn_card = player_deck_collection.remove_card(cards.size() - 1)
	(drawn_card as NewCard3D).face_down = false
	#(drawn_card as NewCard3D).is_in_hand = true
	player_hand_collection.append_card(drawn_card)
	drawn_card.global_position = card_global_position

	if cards.size() == 0:
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


func _on_requested_draw_character_card(_face_down : bool) -> void:
	pass


func _on_done_drawing_initial_character_cards() -> void:
	pass


func _on_accept_button_pressed() -> void:
	GameEvents.accepted_character_cards.emit()
