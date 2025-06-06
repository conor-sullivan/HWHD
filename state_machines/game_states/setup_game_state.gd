extends State
class_name SetupGameState

@export var exclude_characters_state : State

var players_ready = false


func enter() -> void:
	setup_players()
	draw_initial_district_cards()
	players_ready = true


func exit() -> void:
	GameEvents.player_data_changed.emit()


func process_frame(delta : float) -> State:
	if players_ready:
		return exclude_characters_state
	else:
		return null


func setup_players() -> void:
	var real_player = create_player(
		0, 
		"Real Player", 
		"res://assets/avatars/Icon34.png", 
		2, 
		GameData.default_district_deck_card_resource.cards_in_deck.duplicate(),
		false)
	
	GameData.players.append(real_player)
	GameData.current_player = real_player
	GameData.current_player.is_king = true
	
	var computer1 = create_player(
		1, 
		"Computer 1", 
		"res://assets/avatars/Icon35.png", 
		2, 
		GameData.default_district_deck_card_resource.cards_in_deck.duplicate(),
		true)
	
	GameData.players.append(computer1)
	
	var computer2 = create_player(
		1, 
		"Computer 2", 
		"res://assets/avatars/Icon36.png", 
		2, 
		GameData.default_district_deck_card_resource.cards_in_deck.duplicate(),
		true)
	
	GameData.players.append(computer2)

	var computer3 = create_player(
		1, 
		"Computer 3", 
		"res://assets/avatars/Icon37.png", 
		2, 
		GameData.default_district_deck_card_resource.cards_in_deck.duplicate(),
		true)
	
	GameData.players.append(computer3)
	GameEvents.player_data_changed.emit()


func create_player(id : int, name : String, texture_location : String, gold : int, card_resources : Array[DistrictData], is_computer : bool) -> Player:
	var new_player = Player.new()
	new_player.player_id = id
	new_player.player_name = name
	new_player.avatar_texture = load(texture_location)
	new_player.gold_count = gold
	new_player.district_deck_cards = card_resources
	new_player.is_computer = is_computer
	
	return new_player


func draw_initial_district_cards() -> void:
	GameEvents.set_district_deck.emit(GameData.current_player.district_deck_cards)
	
	# real player
	var real_player : Player = null
	var computers : Array[Player]
	
	for player in GameData.players:
		if not player.is_computer:
			real_player = player
		else:
			computers.append(player)
	
	if not real_player:
		#print("no real player")
		return
		
	GameEvents.requested_to_draw_cards_from_district_deck.emit(4)

	# computers
	for computer in computers:
		computer.district_deck_cards.shuffle()
		computer.district_cards_in_hand = computer.district_deck_cards.slice(0, 4)
		computer.district_deck_cards = computer.district_deck_cards.slice(4, computer.district_deck_cards.size())
		computer.district_cards_in_hand_count = computer.district_cards_in_hand.size()
	
	GameEvents.player_data_changed.emit()
	
