extends Node
class_name GameManager

const GAMEUI_SCENE = preload("res://scenes/game_ui/game_ui.tscn")
const DISTRICT_CARD_SCENE = preload("res://scenes/district_card/district_card.tscn")


var players : Array[Player]
var players_turn_id : int = 0
var current_player : Player


func get_default_district_deck_cards() -> Array[DistrictData]:
	return GameData.default_district_deck_card_resources


func add_player(player_to_add : Player) -> void:
	players.append(player_to_add)
	
	GameEvents.player_data_changed.emit()


func update_player(player_to_update : Player) -> void:
	for player in players:
		if player.player_id == player_to_update.player_id:
			player = player_to_update
			
			GameEvents.player_data_changed.emit()


func get_player_by_id(player_id : int) -> Player:
	var player_to_return = null
	for player in players:
		if player.player_id == player_id:
			player_to_return = player
	return player_to_return


func get_solo_real_player() -> Player:
	var player_to_return = null
	for player in players:
		if not player.is_computer:
			player_to_return = player
	return player_to_return



func set_random_king() -> void:
	var random_index = randi_range(0, players.size() -1)
	players[random_index].is_king = true
	
	GameEvents.player_data_changed.emit()


func change_turn() -> void:
	players_turn_id += 1
	if players_turn_id == GameData.players.size():
		players_turn_id = 0
	
	print("turn id ", players_turn_id)
	set_current_player()
	
	GameEvents.player_turn_changed.emit()
	#var game_ui = get_tree().get_first_node_in_group("game_ui")
	#game_ui.queue_free()
	#var new_ui = GAMEUI_SCENE.instantiate()
	#add_child(new_ui)
	#move_child(new_ui, 0)
	#place_cards_back_in_hand()
	#
	#GameEvents.player_data_changed.emit()


func place_cards_back_in_hand() -> void:
	for card in GameData.current_player.district_cards_in_hand:
		var card_scene = DISTRICT_CARD_SCENE.instantiate() as DistrictCard
		card_scene.district_resource = card
		GameEvents.requested_add_district_card_to_hand.emit(card_scene)
		
		if GameData.current_player.is_computer == false:
			card_scene.is_face_down = false


func set_current_player() -> void:
	for player in GameData.players:
		print("player id ", player.player_id)
		if player.player_id == players_turn_id:
			GameData.current_player = player
	
	GameEvents.player_data_changed.emit()


func _on_button_pressed() -> void:
	change_turn()
