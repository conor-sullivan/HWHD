extends Node2D
class_name CharacterCardController

const DEFAULT_CARD_MOVE_SPEED : float = 0.2

var cards_slot_cards : Array[CharacterCard]
var ready_to_begin_picking_cards : bool = true


func _ready() -> void:
	global_position = Vector2(333.0, 250.0)
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
	var i = 0
	var vertical_space = 25

	cards_slot_cards.reverse()

	for card in cards_slot_cards:
		var spacing = i * vertical_space
		GameEvents.requested_move_character_card_to_tracker_container.emit(card, spacing)

		i += 1


func move_pickable_cards_to_character_picker() -> void:
	GameEvents.requested_move_pickable_cards_to_character_picker.emit()
	GameEvents.ready_for_first_player_to_choose_character.emit()


func _on_button_pressed() -> void:
	GameEvents.requested_to_shuffle_character_deck.emit()


func _on_timer_timeout() -> void:
	move_cards_to_character_tracker_container()
	GameEvents.request_make_character_picker_visible.emit()
	move_pickable_cards_to_character_picker()
	$AnimationPlayer.play("destroy_scene")
