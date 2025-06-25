class_name PlayerInPlayCardCollection
extends CardCollection3D


func insert_card(card: Card3D, index: int) -> void:
	super(card, index)
	GameEvents.player_played_district_card.emit(card.resource)
