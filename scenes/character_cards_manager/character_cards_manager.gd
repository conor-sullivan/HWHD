class_name CharacterCardsManager
extends Node3D

@onready var deck_collection = $Deck
@onready var line_collection = $Line

var card_database = TestCardsDatabase.new()


func _ready() -> void:
	var deck : Array[TestCard3D]
	
	for card_type in card_database.character_database:
		deck.push_back(instantiate_face_card(card_type))

	deck.shuffle()
	
	for card in deck:
		card.face_down = true
		deck_collection.append_card(card)
		


func instantiate_face_card(id) -> TestCard3D:
	var scene = load("res://test/test_card_3d.tscn")
	var test_card: TestCard3D = scene.instantiate()
	
	var card_data: Dictionary = card_database.character_database[id]

	test_card.data = card_data
	
	return test_card
