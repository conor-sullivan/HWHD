class_name MagicianAbilityDiscardDisplay extends Control

@export var district_card_scene : PackedScene = preload("res://scenes/district_card_2d/district_card_2d.tscn")


func _ready() -> void:
	GameEvents.requested_show_magician_discard_display.connect(_on_requested_show_magician_discard_display)


func _on_button_pressed() -> void:
	var cards_to_discard : Array[DistrictData]

	for c in get_children():
		if not c is DistrictCard2D:
			return
		
		if (c as DistrictCard2D).is_selected:
			cards_to_discard.append(c.data)

	GameEvents.done_selecting_magician_discards.emit(cards_to_discard)


func _on_requested_show_magician_discard_display() -> void:
	for c in get_children():
		if not c is DistrictCard2D:
			return
		c.queue_free()	
	
	for c in GameData.current_battle.current_players_turn.district_cards_in_hand:
		var instance = district_card_scene.instantiate() as DistrictCard2D
		instance.data = c.data

		add_child(instance)

	show()
