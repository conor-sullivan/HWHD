extends Node2D
class_name CharacterCardController

const DEFAULT_CARD_MOVE_SPEED : float = 0.2

var cards_slot_cards : Array[CharacterCard]
var ready_to_begin_picking_cards : bool = true


func _ready() -> void:
	GameEvents.character_deck_shuffled.connect(_on_character_deck_shuffled)
	GameEvents.played_top_card_of_character_deck.connect(_on_played_top_card_of_character_deck)


func _on_character_deck_shuffled() -> void:
	if not ready_to_begin_picking_cards: 
		return
	if cards_slot_cards.size() == 0:
		GameEvents.requested_to_play_top_card_of_character_deck_face_down.emit()


func _on_played_top_card_of_character_deck(card : CharacterCard) -> void:
	if not card: return
	cards_slot_cards.append(card)
	
	if cards_slot_cards.size() == 4:
		animate_card_to_position(card, $CardSlots/HBoxContainer/FaceUpCardSlot3.global_position)
		GameEvents.character_deck_ready_to_begin_passing_around.emit($CharacterDeck.cards_in_deck, $CharacterDeck.cards_not_in_deck)
		$Timer.start()
	
	if cards_slot_cards.size() == 1:
		animate_card_to_position(card, $CardSlots/HBoxContainer/FaceDownCardSlot.global_position)
		GameEvents.requested_to_play_top_card_of_character_deck_face_up.emit()
		
	if cards_slot_cards.size() == 2:
		animate_card_to_position(card, $CardSlots/HBoxContainer/FaceUpCardSlot1.global_position)
		GameEvents.requested_to_play_top_card_of_character_deck_face_up.emit()
		
	if cards_slot_cards.size() == 3:
		animate_card_to_position(card, $CardSlots/HBoxContainer/FaceUpCardSlot2.global_position)
		GameEvents.requested_to_play_top_card_of_character_deck_face_up.emit()


func animate_card_to_position(card : CharacterCard, new_position : Vector2, speed : float = DEFAULT_CARD_MOVE_SPEED) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", new_position, speed )


func move_cards_to_character_tracker_container() -> void:
	var character_tracker_container = get_tree().get_first_node_in_group("character_tracker_container")
	var character_dect = get_tree().get_first_node_in_group("character_deck")
	
	var i = 0
	var vertical_space = 25
	var vbox = character_tracker_container.find_child("VBoxContainer")

	cards_slot_cards.reverse()

	for card in cards_slot_cards:
		character_dect.remove_child(card)
		card.shrink_scale()
		animate_card_to_position(card, Vector2(vbox.position.x, vbox.position.y - (i * vertical_space)))
		vbox.add_child(card)
		i += 1


func _on_button_pressed() -> void:
	GameEvents.requested_to_shuffle_character_deck.emit()


func _on_timer_timeout() -> void:
	move_cards_to_character_tracker_container()
	$AnimationPlayer.play("destroy_scene")
