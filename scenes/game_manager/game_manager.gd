extends Node
class_name GameManager

const PLAYER_TRACKER_SCENE = preload("res://scenes/player_tracker/player_tracker.tscn")
const DISTRICT_DECK_SCENE = preload("res://scenes/district_deck/district_deck.tscn")
const GAMEUI_SCENE = preload("res://scenes/game_ui/game_ui.tscn")
const DISTRICT_CARD_SCENE = preload("res://scenes/district_card/district_card.tscn")

const district_deck = preload("res://resources/district_decks/default_district_deck.tres")

var players : Array[Player]
var players_turn_id : int = 0
var current_player : Player


func _ready() -> void:
	setup_players()
	create_player_trackers()
	draw_initial_district_cards()
	#set_random_king()
	set_real_player_king()


func setup_players() -> void:
	var real_player = Player.new()
	real_player.player_id = 0
	real_player.player_name = "Real Person"
	real_player.avatar_texture = preload("res://assets/avatars/Icon33.png")
	real_player.gold_count = 2
	real_player.is_computer = false
	real_player.district_deck_cards = district_deck.cards_in_deck.duplicate()
	
	players.append(real_player)
	
	var computer1 = Player.new()
	computer1.player_id = 1
	computer1.player_name = "Computer 1"
	computer1.avatar_texture = preload("res://assets/avatars/Icon34.png")
	computer1.gold_count = 2
	computer1.district_deck_cards = district_deck.cards_in_deck.duplicate()
	
	players.append(computer1)

	var computer2 = Player.new()
	computer2.player_id = 2
	computer2.player_name = "Computer 2"
	computer2.avatar_texture = preload("res://assets/avatars/Icon35.png")
	computer2.gold_count = 2
	computer2.district_deck_cards = district_deck.cards_in_deck.duplicate()
	
	players.append(computer2)

	var computer3 = Player.new()
	computer3.player_id = 3
	computer3.player_name = "Computer 3"
	computer3.avatar_texture = preload("res://assets/avatars/Icon36.png")
	computer3.gold_count = 2
	computer3.district_deck_cards = district_deck.cards_in_deck.duplicate()
	
	players.append(computer3)
	
	GameEvents.player_data_changed.emit()


func get_player_by_id(player_id : int) -> Player:
	var player_to_return = null
	for player in players:
		if player.player_id == player_id:
			player_to_return = player
	return player_to_return


func create_player_trackers() -> void:
	var player_tracker_container = get_tree().get_first_node_in_group("player_tracker_container")
	for player in players:
		var instance = PLAYER_TRACKER_SCENE.instantiate()
		player_tracker_container.add_child(instance)
		instance.player = player
		if player.player_id == players_turn_id:
			instance.play_taking_turn()


func draw_initial_district_cards() -> void:
	# real player
	var real_player : Player = null
	var computers : Array[Player]
	
	for player in players:
		if not player.is_computer:
			real_player = player
		else:
			computers.append(player)
	
	if not real_player:
		return
		
	var district_deck_instance = DISTRICT_DECK_SCENE.instantiate()
	var district_deck_container = get_tree().get_first_node_in_group("district_deck_container")
	
	district_deck_container.add_child(district_deck_instance)
	real_player.district_deck_cards.shuffle()
	district_deck_instance.set_district_deck(real_player.district_deck_cards)
	
	var cards_in_hand = await district_deck_instance.draw_four_cards()
	real_player.district_cards_in_hand = cards_in_hand
	real_player.district_cards_in_hand_count = real_player.district_cards_in_hand.size()
	real_player.district_deck_cards = district_deck_instance.cards_in_deck

	# computers
	for computer in computers:
		computer.district_deck_cards.shuffle()
		computer.district_cards_in_hand = computer.district_deck_cards.slice(0, 4)
		computer.district_deck_cards = computer.district_deck_cards.slice(0, 4)
		computer.district_cards_in_hand_count = computer.district_cards_in_hand.size()
	
	GameEvents.player_data_changed.emit()
	

func set_random_king() -> void:
	var random_index = randi_range(0, players.size() -1)
	players[random_index].is_king = true
	
	GameEvents.player_data_changed.emit()


func set_real_player_king() -> void:
	var real_player : Player = null
	
	for player in players:
		if not player.is_computer:
			real_player = player
	
	real_player.is_king = true
	
	GameEvents.player_data_changed.emit()


func change_turn() -> void:
	players_turn_id += 1
	if players_turn_id == players.size():
		players_turn_id = 0
	
	set_current_player()
	
	var game_ui = get_tree().get_first_node_in_group("game_ui")
	game_ui.queue_free()
	var new_ui = GAMEUI_SCENE.instantiate()
	add_child(new_ui)
	move_child(new_ui, 0)
	create_player_trackers()
	place_cards_back_in_hand()
	GameEvents.player_data_changed.emit()


func place_cards_back_in_hand() -> void:
	var player_hand = get_tree().get_first_node_in_group("player_hand") as PlayerHand
	for card in current_player.district_cards_in_hand:
		if card is DistrictCard:
			player_hand.add_child(card)
			player_hand.add_card_to_hand(card)
			(card as DistrictCard).is_face_down = false
		else:
			var card_scene = DISTRICT_CARD_SCENE.instantiate()
			card_scene.district_resource = card
			player_hand.add_child(card_scene)
			player_hand.add_card_to_hand(card_scene)


func set_current_player() -> void:
	for player in players:
		if player.player_id == players_turn_id:
			current_player = player


func _on_button_pressed() -> void:
	change_turn()
