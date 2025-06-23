class_name PlayerDragController
extends DragController


func _drag_card_start(card: Card3D, drag_from_collection: CardCollection3D) -> void:
	super(card, drag_from_collection)
	if not GameData.current_battle.real_player.can_play_district_card:
		($InPlayCardCollection as PlayerInPlayerCardCollection).disable_drop_zone()
		return
	if card.resource.cost > GameData.current_battle.real_player.gold_count:
		($InPlayCardCollection as PlayerInPlayerCardCollection).disable_drop_zone()
		return
	if GameData.current_battle.current_players_turn == GameData.current_battle.real_player:
		($InPlayCardCollection as PlayerInPlayerCardCollection).enable_drop_zone()
		$InPlayDropzoneShader.show()
	

func _stop_drag(mouse_position: Vector2) -> void:
	super(mouse_position)
	($InPlayCardCollection as PlayerInPlayerCardCollection).disable_drop_zone()
	$InPlayDropzoneShader.hide()
