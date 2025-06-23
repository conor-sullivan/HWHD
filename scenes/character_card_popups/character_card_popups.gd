class_name CharacterCardPopupsHandler
extends Control


func item_popup(_slot, card_data : CharacterData) -> void:
	$CanvasLayer/ItemPopup/Title.text = card_data.character_name
	$CanvasLayer/ItemPopup/Description.text = card_data.special_ability_text
	#$CanvasLayer/ItemPopup2/Initiative.text = str(card_data.play_order_number)
	print(card_data)
	$CanvasLayer/ItemPopup.popup()
	#$CanvasLayer/ItemPopup2.popup()

func hide_item_popup() -> void:
	$CanvasLayer/ItemPopup.hide()
	#$CanvasLayer/ItemPopup2.hide()
