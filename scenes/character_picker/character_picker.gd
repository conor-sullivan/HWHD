extends Control
class_name CharacterPicker


func _ready() -> void:
	GameEvents.request_make_character_picker_visible.connect(make_visible)
	GameEvents.on_moved_pickable_card_to_character_picker.connect(add_to_pickable_cards)


func add_to_pickable_cards(card : CharacterCard) -> void:
	$HBoxContainer.add_child(card)
	await card.play_reveal_flip_animation()
	card.play_waiting_to_pick()
	card.enable_collider()
	


func remove_from_pickable_cards(card : CharacterCard) -> void:
	$HBoxContainer.remove_child(card)


func make_visible() -> void:
	visible = true
