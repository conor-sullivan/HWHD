extends Node2D
class_name CharacterDeck

@export var cards_in_deck : Array[CharacterCard]
@export var random_rotation_amount : float = 0.05

const DEFAULT_CARD_MOVE_SPEED = 0.2

var cards_not_in_deck : Array[CharacterCard]
var center_screen : Vector2 


func _ready() -> void:
	center_screen = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	GameEvents.requested_to_shuffle_character_deck.connect(_on_requested_to_shuffle_character_deck)
	GameEvents.requested_to_play_top_card_of_character_deck_face_down.connect(_on_requested_to_play_top_card_of_character_deck_face_down)
	GameEvents.requested_to_play_top_card_of_character_deck_face_up.connect(_on_requested_to_play_top_card_of_character_deck_face_up)
	GameEvents.requested_move_pickable_cards_to_character_picker.connect(_on_requested_move_pickable_cards_to_character_picker)


func _on_requested_move_pickable_cards_to_character_picker() -> void:
	var character_picker = get_tree().get_first_node_in_group("character_picker") as CharacterPicker
	for card in cards_in_deck:
		print(card)
		#animate_card_to_position(card, center_screen)
		remove_child(card)
		character_picker.add_to_pickable_cards(card)
	


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


func animate_card_to_position(card : CharacterCard, new_position : Vector2, speed : float = DEFAULT_CARD_MOVE_SPEED) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed )
