class_name OpponentTurnState extends State

@export var player_turn_state : State
@export var end_of_round_state : State

var player : Player
var ai = AI.new()
var has_picked_action : bool = false
var has_used_ability : bool = false
var has_played_district_card : bool = false
var can_play_district_card : bool = false
var ready_to_take_next_action : bool = false
var is_turn_ended : bool = false


func enter() -> void:
	print('opponent turn state')

	GameEvents.done_with_opponent_ability.connect(_on_done_with_opponent_ability)
#	GameEvents.opponent_deck_cards_ready_for_gain_card_action.connect(_on_opponent_deck_cards_ready_for_gain_card_action)
	GameEvents.started_player_turn_state.emit()
	
	is_turn_ended = false
	has_picked_action = false
	has_used_ability = false
	has_played_district_card = false
	can_play_district_card = false

	player = GameData.current_battle.opponent_player

	if player.will_be_assassinated:
		GameEvents.requested_new_in_battle_notification.emit(player.player_name, null, 'was assassinated and skips thier turn', '')
		is_turn_ended = true
		return


	if player.will_be_robbed:
		GameEvents.requested_player_rob_player.emit(GameData.current_battle.real_player, player)

	$Timer.start()
	player.has_taken_turn = false
	player.can_play_district_card = true
	player.can_use_character_ability = true
	player.character_avatar_visible = true

	GameData.current_battle.current_players_turn = player


func exit() -> void:
	# Loop through all signals defined in GameEvents
	for signal_info in GameEvents.get_signal_list():
		var signal_name = signal_info.name
		# Check if this signal is connected to any method in this script
		for method in self.get_method_list():
			var method_name = method.name
			if GameEvents.is_connected(signal_name, Callable(self, method_name)):
				GameEvents.disconnect(signal_name, Callable(self, method_name))

	GameData.current_battle.opponent_player.has_taken_turn = true


func setup_ai() -> void:
	var ai_player = GameData.current_battle.opponent_player
	var real_player = GameData.current_battle.real_player
	
	var crown_holder : Player
	var player_order : Array[Player]
	
	if ai_player.is_king:
		crown_holder = ai_player
		player_order.append(ai_player)
		player_order.append(real_player)
	else:
		crown_holder = real_player
		player_order.append(real_player)
		player_order.append(ai_player)
		
		
	ai.set_player_states(ai_player, real_player)
	ai.set_game_state(player_order, crown_holder, GameData.current_battle.round_number)
	
	ai.difficulty = GameData.current_battle.difficulty 
	

# gold or cards
func gold_or_card() -> void:
	var result = ai.choose_gain_gold_or_card()

	if result == 'gold':
		player.gold_count += 2
		GameEvents.player_gained_gold.emit(player, 2)
	elif result == 'card':
		var card1 = player.district_deck_cards[player.district_deck_cards.size() - 1]
		var card2 = player.district_deck_cards[player.district_deck_cards.size() - 2]
		_on_opponent_deck_cards_ready_for_gain_card_action([card1, card2])

	ready_to_take_next_action = false
	$Timer.start()
	GameEvents.requested_opponent_gain_card_action.emit()


# use special ability
func use_character_ability() -> void:
	var ability = load(player.current_character_card.ability_function_path).new()

	if ability:
		ability.opponent_do_ability()

	ready_to_take_next_action = false
	$Timer.start()

# play district card
func play_district_card() -> void:
	for c in player.district_cards_in_hand:
		print(c.district_name)
	setup_ai()
	var card = ai.choose_district_card_to_play()
	if not card:
		return

	var current_gold = player.gold_count
	player.gold_count = current_gold - card.cost
	
	GameEvents.player_spent_gold.emit(player, card.cost)
	
	GameEvents.requested_opponent_play_card_from_hand.emit(card)
	player.districts_played_this_turn += 1
	player.district_cards_in_play += [card]

	ready_to_take_next_action = false
	$Timer.start()


func process_frame(_delta :  float) -> State:
	if is_turn_ended:
		if GameData.current_battle.real_player.has_taken_turn:
			return end_of_round_state
		else:
			return player_turn_state
		
	if not player:
		return null

	if not ready_to_take_next_action:
		return null

	if not has_picked_action:
		gold_or_card()
		has_picked_action = true
		return null

	if not has_used_ability:
		use_character_ability()
		has_used_ability = true
		return null

	if not has_played_district_card: 
		play_district_card()
		has_played_district_card = true

		return null
	
	if has_picked_action and has_used_ability and has_played_district_card:
		if GameData.current_battle.real_player.has_taken_turn:
			return end_of_round_state
		else:
			return player_turn_state

	return null


func _on_opponent_deck_cards_ready_for_gain_card_action(cards : Array[DistrictData]) -> void:
	print('this right here')
	#if player != _player:
		#return

	var card_to_keep = ai.choose_between_two_district_cards(cards[0], cards[1])

	cards.erase(card_to_keep)
	
	var card_to_discard = cards[0]
	var _card_to_keep = preload("res://scenes/new_card_3d/new_card_3d.tscn").instantiate() as NewCard3D
	
	_card_to_keep.resource = card_to_keep
	
	var _card_to_keep_data = {
		"id" : card_to_keep.district_name,
		"front_material" : card_to_keep.front_material,
		"back_material" : card_to_keep.back_material,
		"coin_cost" : card_to_keep.cost,
		"sprite_texture" : card_to_keep.sprite_texture
	}
	
	_card_to_keep.data = _card_to_keep_data
	
	_card_to_keep.face_down = false
	
	GameEvents.requested_append_card_in_player_hand.emit(GameData.current_battle.opponent_player, _card_to_keep)
	_card_to_keep.global_position = Vector3(0, 0, -1)
#	GameData.current_battle.opponent_player.district_cards_in_hand += [_card_to_keep.resource]


	var _card_to_discard = preload("res://scenes/new_card_3d/new_card_3d.tscn").instantiate() as NewCard3D
	
	_card_to_discard.resource = card_to_discard
	
	var _card_to_discard_data = {
		"id" : card_to_discard.district_name,
		"front_material" : card_to_discard.front_material,
		"back_material" : card_to_discard.back_material,
		"coin_cost" : card_to_discard.cost,
		"sprite_texture" : card_to_discard.sprite_texture
	}
	
	_card_to_discard.data = _card_to_discard_data
	_card_to_discard.face_down = false

	
	GameEvents.requested_append_card_in_player_discard.emit(GameData.current_battle.opponent_player, _card_to_discard)
	_card_to_discard.global_position = Vector3(0, 0, -1)
	
	player.is_picking_action = false
	has_picked_action = true


func _on_done_with_opponent_ability() -> void:
	has_used_ability = true


func _on_timer_timeout() -> void:
	ready_to_take_next_action = true
