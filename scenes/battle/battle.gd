class_name Battle
extends Node3D


@export var duplicate_cards = 2

@onready var player_deck_collection = $PlayerDragController/DeckCardCollection
@onready var player_hand_collection = $PlayerDragController/HandCardCollection
@onready var player_discard_collection = $PlayerDragController/DiscardCollection
@onready var opponent_deck_collection = $OpponentDragController/DeckCardCollection
@onready var opponent_hand_collection = $OpponentDragController/HandCardCollection
@onready var opponent_discard_collection = $OpponentDragController/DiscardCollection
@onready var opponent_in_play_card_collection = $OpponentDragController/InPlayCardCollection

@export var district_resources : Array[DistrictData]


func _ready() -> void:
	GameEvents.requested_player_rob_player.connect(_on_requested_player_rob_player)
	GameEvents.requested_new_in_battle_notification.connect(_on_requested_new_in_battle_notification)
	GameEvents.requested_opponent_play_card_from_hand.connect(_on_requested_opponent_play_card_from_hand)
	GameEvents.requested_player_discard_cards.connect(_on_requested_player_discard_cards)
	GameEvents.requested_players_exchange_hands.connect(_on_requested_players_exchange_hands)
	GameEvents.district_card_destroyed_by_warlord.connect(_on_district_card_destroyed_by_warlord)
	GameEvents.done_drawing_initial_character_cards.connect(_on_done_drawing_initial_character_cards)
	GameEvents.ready_to_exclude_characters.connect(_on_ready_to_exclude_characters)
	GameEvents.requested_player_draw_district_cards.connect(_on_requested_player_draw_district_cards)
	
	var player_deck : Array[NewCard3D]
	var opponent_deck : Array[NewCard3D]
	var character_deck : Array[NewCard3D]
	
	for card_id in district_resources:
		for duplicate_card in duplicate_cards:
			GameData.player_current_district_deck_build.push_back(card_id)
			var player_card = instantiate_district_card(card_id.district_name)
			player_card.is_real_players = true
			player_deck.push_back(player_card)
			opponent_deck.push_back(instantiate_district_card(card_id.district_name))

	player_deck.shuffle()
	opponent_deck.shuffle()
	character_deck.shuffle()
	
	for card in player_deck:
#		card.face_down = true
		player_deck_collection.append_card(card)
		
	for card in opponent_deck:
#		card.face_down = true
		opponent_deck_collection.append_card(card)
	


func instantiate_district_card(id : String) -> NewCard3D:
	var scene = load("res://scenes/new_card_3d/new_card_3d.tscn")
	var test_card: NewCard3D = scene.instantiate()
	var card_data : Dictionary

	
	for district_card in district_resources:
		if district_card.district_name == id:
			test_card.resource = district_card
			card_data = {
				"id" : id,
				"front_material": district_card.front_material,
				"back_material": district_card.back_material,
				"coin_cost": district_card.cost,
				'sprite_texture' : district_card.sprite_texture
			}
	test_card.data = card_data
	
	
	return test_card


func _on_requested_player_rob_player(robbing_player : Player, robbed_player : Player) -> void:
	GameEvents.player_spent_gold.emit(robbed_player, robbed_player.gold_count)
	GameEvents.player_gained_gold.emit(robbing_player, robbed_player.gold_count)

	robbing_player.gold_count += robbed_player.gold_count
	robbed_player.gold_count = 0


func _on_requested_new_in_battle_notification(_name, texture, action, target) -> void:
	print(_name, texture, action, target)


func _on_requested_opponent_play_card_from_hand(card_data : DistrictData) -> void:
	for c in opponent_hand_collection.cards:
		if c.resource == card_data:
			var card_index = opponent_hand_collection.cards.find(c)
			opponent_hand_collection.remove_card(card_index)
			opponent_in_play_card_collection.append_card(c)
			c.face_down = false
			break


func _on_requested_player_discard_cards(player : Player, cards_to_discard : Array[DistrictData]) -> void:
	print('player to discard cards...')
	
	if player.is_computer:
		_discard_cards_from_collection(cards_to_discard, opponent_hand_collection, opponent_discard_collection)
	else:
		_discard_cards_from_collection(cards_to_discard, player_hand_collection, player_discard_collection)


func _discard_cards_from_collection(cards_to_discard: Array[DistrictData], hand_collection, discard_collection) -> void:
	for card in cards_to_discard:
		for c in hand_collection.get_children():
			if c is NewCard3D and card == c.resource:
				var card_index = hand_collection.cards.find(c)
				hand_collection.remove_card(card_index)
				discard_collection.append_card(c)


# clicking on deck adds card to hand
func _on_deck_card_collection_card_clicked(_card: Variant) -> void:
	player_draw_card()


func _on_opponent_deck_card_collection_card_clicked(_card: Variant) -> void:
	opponent_draw_card()


func player_draw_card() -> void:
	var cards = player_deck_collection.cards
	var card_global_position = cards[cards.size() - 1].global_position
	var drawn_card = player_deck_collection.remove_card(cards.size() - 1)
	(drawn_card as NewCard3D).face_down = false
	(drawn_card as NewCard3D).player_owner = GameData.current_battle.real_player
	#(drawn_card as NewCard3D).is_in_hand = true
	player_hand_collection.append_card(drawn_card)
	drawn_card.global_position = card_global_position

	GameData.current_battle.real_player.district_cards_in_hand += [(drawn_card as NewCard3D).resource]


	if cards.size() == 0:
		var timer = get_tree().create_timer(.1)
		await timer.timeout
		$PlayerDragController/EmptyDeck.visible = true

	var new_deck_data : Array[DistrictData]
	for c in player_deck_collection.cards:
		new_deck_data.push_back(c.resource)

	GameData.current_battle.real_player.district_deck_cards = new_deck_data


func opponent_draw_card() -> void:
	var cards = opponent_deck_collection.cards
	var card_global_position = cards[cards.size() - 1].global_position
	var drawn_card = opponent_deck_collection.remove_card(cards.size() - 1)
	(drawn_card as NewCard3D).face_down = false
	(drawn_card as NewCard3D).player_owner = GameData.current_battle.opponent_player
	opponent_hand_collection.append_card(drawn_card)
	drawn_card.global_position = card_global_position
	
	GameData.current_battle.opponent_player.district_cards_in_hand += [(drawn_card as NewCard3D).resource]

	if cards.size() == 0:
		var timer = get_tree().create_timer(.1)
		await timer.timeout
		$OpponentDragController/OpponentEmptyDeck.visible = true
	
	var new_deck_data : Array[DistrictData]
	for c in opponent_deck_collection.cards:
		new_deck_data.push_back(c.resource)

	GameData.current_battle.opponent_player.district_deck_cards = new_deck_data


func _on_requested_player_draw_district_cards(player : Player, count : int) -> void:
	if player.is_computer:
		for i in count:
			await get_tree().create_timer(0.05).timeout
			opponent_draw_card()
	if not player.is_computer:
		for i in count:
			await get_tree().create_timer(0.05).timeout
			player_draw_card()


func _on_ready_to_exclude_characters() -> void:
	pass


func _on_requested_draw_character_card(_face_down : bool) -> void:
	pass


func _on_done_drawing_initial_character_cards() -> void:
	pass


func _on_accept_button_pressed() -> void:
	GameEvents.accepted_character_cards.emit()


func _on_district_card_destroyed_by_warlord(card_owner : Player, card : DistrictData) -> void:
	var instance = instantiate_district_card(card.district_name)
	(instance as NewCard3D).face_down = false
#	instance.global_position = Vector3.ZERO
	(instance as NewCard3D).player_owner = GameData.current_battle.opponent_player
	if card_owner.is_computer:
		opponent_hand_collection.append_card(instance)
	else:
		player_discard_collection.append_card(instance)


func _on_requested_players_exchange_hands() -> void:
	opponent_hand_collection.remove_all()
	player_hand_collection.remove_all()

	for c in GameData.current_battle.real_player.district_cards_in_hand:
		var instance = instantiate_district_card(c.district_name)
		player_hand_collection.append_card(instance)
	
	for c in GameData.current_battle.opponent_player.district_cards_in_hand:
		var instance = instantiate_district_card(c.district_name)
		opponent_hand_collection.append_card(instance)
# 		instance.face_down = true
