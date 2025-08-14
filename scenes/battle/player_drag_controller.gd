class_name PlayerDragController
extends DragController


func _drag_card_start(card: Card3D, drag_from_collection: CardCollection3D) -> void:
	super(card, drag_from_collection)
	if not GameData.current_battle.real_player.can_play_district_card:
		($InPlayCardCollection as PlayerInPlayCardCollection).disable_drop_zone()
		return
	if card.resource.district_name == 'Necropolis':
		if can_afford_necropolis():
			($InPlayCardCollection as PlayerInPlayCardCollection).enable_drop_zone()
			$InPlayDropzoneShader.show()
			return
	if card.resource.cost > GameData.current_battle.real_player.gold_count:
		($InPlayCardCollection as PlayerInPlayCardCollection).disable_drop_zone()
		return
	if GameData.current_battle.current_players_turn == GameData.current_battle.real_player:
		($InPlayCardCollection as PlayerInPlayCardCollection).enable_drop_zone()
		$InPlayDropzoneShader.show()
	

func can_afford_necropolis() -> bool:
	var cost = 5
	if GameData.current_battle.real_player.gold_count >= cost:
		return true
	if GameData.current_battle.real_player.district_cards_in_play_count > 0:
		return true
	return false


func _stop_drag(mouse_position: Vector2) -> void:
	super(mouse_position)
	($InPlayCardCollection as PlayerInPlayCardCollection).disable_drop_zone()
	$InPlayDropzoneShader.hide()
