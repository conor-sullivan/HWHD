class_name DeckCardCollection
extends CardCollection3D

func can_insert_card(_card: NewCard3D, _from_collection) -> bool:
	return false


func can_select_card(_card: NewCard3D) -> bool:
	return false


func can_reorder_card(_card: NewCard3D) -> bool:
	return false


func can_remove_card(_card: NewCard3D) -> bool:
	return false
