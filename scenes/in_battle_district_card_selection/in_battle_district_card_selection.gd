class_name InBattleDistrictCardSelection
extends Control

var default_scale = Vector2(0.24, 0.24)
var right_card_data : DistrictData :
	set(data):
		right_card_data = data
		set_sprites(null, right_card_data)
var left_card_data : DistrictData : 
	set(data):
		left_card_data = data
		set_sprites(left_card_data, null)


func _ready() -> void:
	GameEvents.deck_cards_ready_for_gain_card_action.connect(_on_deck_cards_ready_for_gain_card_action)


func _on_deck_cards_ready_for_gain_card_action(player : Player, cards : Array[DistrictData]) -> void:
	right_card_data = cards[0]
	left_card_data = cards[1]
	set_scales_to_default()
	show()
	
	
func set_scales_to_default() -> void:
	var tween = new_tween_scale()
	tween.tween_property(%LeftCardSprite, "scale", default_scale, 0.2)
	
	tween = new_tween_scale()
	tween.tween_property(%RightCardSprite, "scale", default_scale, 0.2)


func set_sprites(left_card : DistrictData, right_card : DistrictData) -> void:
	if left_card:
		%LeftCardSprite.texture = left_card.sprite_texture
	if right_card:
		%RightCardSprite.texture = right_card.sprite_texture


func new_tween_scale() -> Tween:
	var scale_tween : Tween = create_tween()
	scale_tween.set_ease(Tween.EASE_IN_OUT)
	scale_tween.set_trans(Tween.TRANS_CUBIC)

	return scale_tween


func tween_discarded_card(card : Sprite2D) -> void:
	var tween = new_tween_scale()
	tween.tween_property(card, "scale", Vector2.ZERO, 0.2)


func tween_selected_card(card : Sprite2D) -> void:
	var tween = new_tween_scale()
	tween.tween_property(card, "scale", default_scale * 1.3, 0.2)
	
	await tween.finished
	
	tween = new_tween_scale()
	tween.tween_property(card, "scale", Vector2.ZERO, 0.2)


func _on_left_card_mouse_entered() -> void:
	var tween = new_tween_scale()
	tween.tween_property(%LeftCardSprite, "scale", default_scale * 1.1, 0.2)


func _on_left_card_mouse_exited() -> void:
	var tween = new_tween_scale()
	tween.tween_property(%LeftCardSprite, "scale", default_scale, 0.2)


func _on_right_card_mouse_entered() -> void:
	var tween = new_tween_scale()
	tween.tween_property(%RightCardSprite, "scale", default_scale * 1.1, 0.2)


func _on_right_card_mouse_exited() -> void:
	var tween = new_tween_scale()
	tween.tween_property(%RightCardSprite, "scale", default_scale, 0.2)


func _on_left_card_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			tween_selected_card(%LeftCardSprite)
			tween_discarded_card(%RightCardSprite)
			
			await get_tree().create_timer(0.5).timeout
			hide()
			GameEvents.player_picked_district_card_to_keep.emit(
				GameData.current_battle.current_players_turn, 
				left_card_data, # keep
				right_card_data # discard
				)
				

func _on_right_card_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			tween_selected_card(%RightCardSprite)
			tween_discarded_card(%LeftCardSprite)
			
			await get_tree().create_timer(0.5).timeout
			hide()
			GameEvents.player_picked_district_card_to_keep.emit(
				GameData.current_battle.current_players_turn, 
				right_card_data, # keep
				left_card_data # discard
				)
