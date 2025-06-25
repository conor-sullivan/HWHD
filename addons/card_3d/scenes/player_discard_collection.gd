class_name PlayerDiscardCollection
extends CardCollection3D


func _ready() -> void:
	GameEvents.requested_append_card_in_player_discard.connect(_on_requested_append_card_in_player_discard)
	

func _on_requested_append_card_in_player_discard(player : Player, card : NewCard3D) -> void:
	append_card(card)
