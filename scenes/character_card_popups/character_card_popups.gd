class_name CharacterCardPopupsHandler
extends Control

func _ready() -> void:
	hide_item_popup()


func item_popup(_slot, card_data : CharacterData) -> void:
	print('pop', card_data.character_name)
	$CanvasLayer/ItemPopup/Title.text = card_data.character_name
	$CanvasLayer/ItemPopup/Description.text = card_data.special_ability_text
	$CanvasLayer/ItemPopup/Initiative.text = 'Initiative: ' + str(card_data.play_order_number)
	$CanvasLayer/ItemPopup.popup()

func hide_item_popup() -> void:
	$CanvasLayer/ItemPopup.hide()
