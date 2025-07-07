class_name MagicianAbilityDisplay
extends Control

@export var default_scale = 0.8
@export var scale_multiplier = 1.1


func _ready() -> void:
	GameEvents.starting_magician_ability.connect(_on_starting_magician_ability)


func _on_starting_magician_ability() -> void:
	show()
	show_tween()


func exchange_hands() -> void:
	var player_hand = GameData.current_battle.real_player.district_cards_in_hand.duplicate()
	var opponent_hand = GameData.current_battle.opponent_player.district_cards_in_hand.duplicate()

	GameData.current_battle.real_player.district_cards_in_hand = opponent_hand
	GameData.current_battle.opponent_player.district_cards_in_hand = player_hand

	GameEvents.requested_players_exchange_hands.emit()
	GameData.current_battle.real_player.can_use_character_ability = false


func discard() -> void:
	GameEvents.requested_show_magician_discard_display.emit()


func new_scale_tween() -> Tween:
	var tween : Tween = create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	return tween


func show_tween() -> void:
	%ExchangeHandsOption.scale = Vector2.ZERO
	%DiscardOption.scale = Vector2.ZERO
	
	var tween = new_scale_tween()
	tween.tween_property(%ExchangeHandsOption, "scale", Vector2.ONE * default_scale, 0.2)
	await get_tree().create_timer(0.1).timeout
	var tween2 = new_scale_tween()
	tween2.tween_property(%DiscardOption, "scale", Vector2.ONE * default_scale, 0.2)


func tween_selected(selected_option : TextureRect) -> void:
	var tween = new_scale_tween()
	tween.tween_property(selected_option, "scale", Vector2.ONE * default_scale * 1.5, 0.2)
	
	await get_tree().create_timer(0.2).timeout
	
	var tween2 = new_scale_tween()
	tween2.tween_property(selected_option, "scale", Vector2.ZERO, 0.2)


func tween_not_selected(not_selected_option : TextureRect) -> void:
	var tween = new_scale_tween()
	tween.tween_property(not_selected_option, "scale", Vector2.ZERO, 0.2)
	
	await get_tree().create_timer(0.5).timeout


func _on_discard_option_mouse_entered() -> void:
	var tween = new_scale_tween()
	tween.tween_property(%DiscardOption, "scale", Vector2.ONE * default_scale * scale_multiplier, 0.2)


func _on_discard_option_mouse_exited() -> void:
	var tween = new_scale_tween()
	tween.tween_property(%DiscardOption, "scale", Vector2.ONE * default_scale, 0.2)


func _on_exchange_hands_option_mouse_entered() -> void:
	var tween = new_scale_tween()
	tween.tween_property(%ExchangeHandsOption, "scale", Vector2.ONE * default_scale * scale_multiplier, 0.2)


func _on_exchange_hands_option_mouse_exited() -> void:
	var tween = new_scale_tween()
	tween.tween_property(%ExchangeHandsOption, "scale", Vector2.ONE * default_scale, 0.2)


func _on_exchange_hands_option_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tween_selected(%ExchangeHandsOption)
			tween_not_selected(%DiscardOption)
			
			await get_tree().create_timer(0.5).timeout
			
			hide()
			
			GameEvents.in_battle_action_selected.emit(exchange_hands)


func _on_discard_option_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tween_selected(%DiscardOption)
			tween_not_selected(%ExchangeHandsOption)
			
			await get_tree().create_timer(0.5).timeout
			
			hide()
			
			GameEvents.in_battle_action_selected.emit(discard)
