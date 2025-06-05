extends Control
class_name TurnActionUI


func disable_ability_buttons() -> void:
	$VBoxContainer/GoldButton.disabled = true
	$VBoxContainer/CardButton.disabled = true


func _on_gold_button_pressed() -> void:
	GameEvents.gained_gold.emit(2)
	disable_ability_buttons()


func _on_card_button_pressed() -> void:
	GameEvents.drew_cards_from_district_deck.emit(2)
	disable_ability_buttons()


func _on_ability_button_pressed() -> void:
	GameEvents.activated_special_ability.emit()


func _on_end_turn_button_pressed() -> void:
	GameEvents.ended_turn.emit()
