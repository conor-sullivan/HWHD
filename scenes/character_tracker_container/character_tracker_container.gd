extends Control
class_name CharacterTrackerContainer


func _ready() -> void:
	GameEvents.on_character_card_moved_to_tracker_container.connect(add_card)


func add_card(card : CharacterCard) -> void:
	$VBoxContainer.add_child(card)
