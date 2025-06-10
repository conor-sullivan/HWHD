extends Control
class_name CharacterTrackerContainer


func _ready() -> void:
	GameEvents.on_character_card_moved_to_tracker_container.connect(add_card)


func add_card(card : CharacterCard) -> void:
	$VBoxContainer.add_child(card)
	var log : String
	if card.is_face_down_card:
		log = "??? removed from play"
	else:
		log = str(card.character_resource.character_name) + " removed from play"
	GameEvents.requested_new_log_item.emit(log)
