extends Node2D
class_name CharacterDeck

@export var cards_in_deck : Array[CharacterCard]
@export var random_rotation_amount : float = 0.05

var cards_not_in_deck : Array[CharacterCard]


func _ready() -> void:
	GameEvents.requested_to_shuffle_character_deck.connect(_on_requested_to_shuffle_character_deck)
	GameEvents.requested_to_play_top_card_of_character_deck_face_down.connect(_on_requested_to_play_top_card_of_character_deck_face_down)
	GameEvents.requested_to_play_top_card_of_character_deck_face_up.connect(_on_requested_to_play_top_card_of_character_deck_face_up)


func _on_requested_to_shuffle_character_deck() -> void:
	shuffle_character_deck()
	GameEvents.character_deck_shuffled.emit()


func _on_requested_to_play_top_card_of_character_deck_face_down() -> void:
	var card = await play_top_card_face_down()
	GameEvents.played_top_card_of_character_deck.emit(card)


func _on_requested_to_play_top_card_of_character_deck_face_up() -> void:
	var card = await play_top_card_face_up()
	GameEvents.played_top_card_of_character_deck.emit(card)


func shuffle_character_deck() -> void:
	cards_in_deck.shuffle()
	for card in cards_in_deck:
		move_child(card, cards_in_deck.find(card))
		card.rotation = randf_range(-random_rotation_amount, random_rotation_amount)


func play_top_card_face_down() -> CharacterCard:
	var card = cards_in_deck[cards_in_deck.size() - 1]
	cards_not_in_deck.append(card)
	cards_in_deck.erase(card)
	card.play_place_card_animation()
	return card


func play_top_card_face_up() -> CharacterCard:
	var card = cards_in_deck[cards_in_deck.size() - 1]
	cards_not_in_deck.append(card)
	cards_in_deck.erase(card)
	card.play_place_card_animation()
	card.play_reveal_flip_animation()
	return card
