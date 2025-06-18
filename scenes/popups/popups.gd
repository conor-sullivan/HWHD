class_name PopupsHandler
extends Control




func item_popup(_slot : Rect2i, card_data : CharacterData) -> void:
	#var mouse_position = get_global_mouse_position()
	#var correction : Vector2i
	#var padding : int = 10
	#var center = get_viewport_rect().size / 2
	#var size = $CanvasLayer/ItemPopup.size
	#
	#if mouse_position.x <= get_viewport_rect().size.x / 2:
		#correction = Vector2i(slot.size.x, 0)
	#else:
		#correction = -Vector2i($CanvasLayer/ItemPopup.size.x + padding, 0)
	#
	$CanvasLayer/ItemPopup/Title.text = card_data.character_name
	$CanvasLayer/ItemPopup/Description.text = card_data.special_ability_text
	$CanvasLayer/ItemPopup.popup()

func hide_item_popup() -> void:
	$CanvasLayer/ItemPopup.hide()
