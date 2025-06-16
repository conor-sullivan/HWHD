class_name TestGame
extends Node3D


@export var duplicate_cards = 1

@onready var player_deck_collection = $PlayerDragController/DeckCardCollection
@onready var player_hand_collection = $PlayerDragController/HandCardCollection
@onready var opponent_deck_collection = $OpponentDragController/DeckCardCollection
@onready var opponent_hand_collection = $OpponentDragController/HandCardCollection
@onready var character_deck_collection = $CharacterDragController/CharacterDeckCollection

var card_database = CardsDatabase.new()


enum CardType {
	District, Character
}

func _ready() -> void:
	var player_deck : Array[TestCard3D]
	var opponent_deck : Array[TestCard3D]
	var character_deck : Array[TestCard3D]
	
	for card_id in card_database.district_database:
		for duplicate_card in duplicate_cards:
			player_deck.push_back(instantiate_face_card(card_id, CardType.District))
			opponent_deck.push_back(instantiate_face_card(card_id, CardType.District))
	
	for card_id in card_database.character_database:
		character_deck.push_back(instantiate_face_card(card_id, CardType.Character))

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


func instantiate_face_card(id : String, type : CardType) -> TestCard3D:
	var scene = load("res://scenes/new_card_3d/new_card_3d.tscn")
	var test_card: TestCard3D = scene.instantiate()
	var card_data : Dictionary
	
	if type == CardType.District:
		card_data = card_database.district_database[id]
	if type == CardType.Character:
		card_data = card_database.character_database[id]
		
	test_card.data = card_data
	
	return test_card

# clicking on deck adds card to hand
func _on_deck_card_collection_card_clicked(_card: Variant) -> void:
	var cards = player_deck_collection.cards
	var card_global_position = cards[cards.size() - 1].global_position
	var drawn_card = player_deck_collection.remove_card(cards.size() - 1)
	(drawn_card as TestCard3D).face_down = false
	player_hand_collection.append_card(drawn_card)
	drawn_card.global_position = card_global_position

	if cards.size() == 0:
		#await(get_tree().create_timer(.1), "timeout")
		var timer = get_tree().create_timer(.1)
		await timer.timeout
		$PlayerDragController/EmptyDeck.visible = true


func _on_opponent_deck_card_collection_card_clicked(card: Variant) -> void:
	var cards = opponent_deck_collection.cards
	var card_global_position = cards[cards.size() - 1].global_position
	var drawn_card = opponent_deck_collection.remove_card(cards.size() - 1)
	(drawn_card as TestCard3D).face_down = true
	opponent_hand_collection.append_card(drawn_card)
	drawn_card.global_position = card_global_position

	if cards.size() == 0:
		#await(get_tree().create_timer(.1), "timeout")
		var timer = get_tree().create_timer(.1)
		await timer.timeout
		$OpponentDragController/OpponentEmptyDeck.visible = true
