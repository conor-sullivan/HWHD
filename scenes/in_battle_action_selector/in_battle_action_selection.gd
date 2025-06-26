class_name InBattleActionSelection
extends Control

@export var default_scale = 0.8
@export var scale_multiplier = 1.1


func _ready() -> void:
	GameEvents.player_ready_to_choose_action.connect(_on_player_ready_to_choose_action)


func _on_player_ready_to_choose_action() -> void:
	show()
	show_tween()


func gain_2_gold() -> void:
	GameEvents.player_gained_gold.emit(GameData.current_battle.current_players_turn, 2)


func gain_card() -> void:
	GameEvents.requested_gain_card_action.emit(GameData.current_battle.current_players_turn)


func new_scale_tween() -> Tween:
	var tween : Tween = create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	return tween


func show_tween() -> void:
	%CardOption.scale = Vector2.ZERO
	%GoldOption.scale = Vector2.ZERO
	
	var tween = new_scale_tween()
	tween.tween_property(%CardOption, "scale", Vector2.ONE * default_scale, 0.2)
	await get_tree().create_timer(0.1).timeout
	var tween2 = new_scale_tween()
	tween2.tween_property(%GoldOption, "scale", Vector2.ONE * default_scale, 0.2)


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


func _on_gold_option_mouse_entered() -> void:
	var tween = new_scale_tween()
	tween.tween_property(%GoldOption, "scale", Vector2.ONE * default_scale * scale_multiplier, 0.2)


func _on_gold_option_mouse_exited() -> void:
	var tween = new_scale_tween()
	tween.tween_property(%GoldOption, "scale", Vector2.ONE * default_scale, 0.2)


func _on_card_option_mouse_entered() -> void:
	var tween = new_scale_tween()
	tween.tween_property(%CardOption, "scale", Vector2.ONE * default_scale * scale_multiplier, 0.2)


func _on_card_option_mouse_exited() -> void:
	var tween = new_scale_tween()
	tween.tween_property(%CardOption, "scale", Vector2.ONE * default_scale, 0.2)


func _on_card_option_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tween_selected(%CardOption)
			tween_not_selected(%GoldOption)
			
			await get_tree().create_timer(0.5).timeout
			
			hide()
			
			GameEvents.in_battle_action_selected.emit(gain_card)


func _on_gold_option_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tween_selected(%GoldOption)
			tween_not_selected(%CardOption)
			
			await get_tree().create_timer(0.5).timeout
			
			hide()
			
			GameEvents.in_battle_action_selected.emit(gain_2_gold)
