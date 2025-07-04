class_name PlayerInPlayCardCollection
extends CardCollection3D


func insert_card(card: Card3D, index: int) -> void:
	super(card, index)
	GameEvents.player_played_district_card.emit(card.resource)
	card.is_in_play = true


func can_insert_card(_card: NewCard3D, _from_collection) -> bool:
	return true


func can_select_card(_card: NewCard3D) -> bool:
	return false


func can_reorder_card(_card: NewCard3D) -> bool:
	return false


func can_remove_card(_card: NewCard3D) -> bool:
	return false
