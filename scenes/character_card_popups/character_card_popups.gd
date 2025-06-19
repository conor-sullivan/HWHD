class_name CharacterCardPopupsHandler
extends Control


func item_popup(_slot : Rect2i, card_data : CharacterData) -> void:
	$CanvasLayer/ItemPopup/Title.text = card_data.character_name
	$CanvasLayer/ItemPopup/Description.text = card_data.special_ability_text
	$CanvasLayer/ItemPopup.popup()

func hide_item_popup() -> void:
	$CanvasLayer/ItemPopup.hide()
