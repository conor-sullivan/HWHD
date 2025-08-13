class_name PlayerTurnState
extends State

@export var opponent_turn_state : State
@export var end_of_round_state : State

var player : Player
var is_turn_ended : bool = false


func enter() -> void:
	print('player turn state')
	GameEvents.player_chose_action.connect(_on_player_chose_action)
	GameEvents.end_player_turn.connect(_on_end_player_turn)
	GameEvents.in_battle_action_selected.connect(_on_in_battle_action_selected)
	GameEvents.player_played_district_card.connect(_on_player_played_district_card)
	GameEvents.started_player_turn_state.emit()
	GameEvents.player_picked_district_card_to_keep.connect(_on_player_picked_district_card_to_keep)
	
	is_turn_ended = false

	player = GameData.current_battle.real_player
	GameData.current_battle.current_players_turn = player 
	
	if player.will_be_assassinated and DistrictAbilitiesManager.can_player_take_turn_when_assassinated(player):
		player.has_taken_turn = false
		player.can_play_district_card = false
		player.can_use_character_ability = false
		player.character_avatar_visible = true
		player.is_picking_action = true
		player.in_play_districts_can_be_targeted = true
		
		await get_tree().create_timer(3).timeout
		GameEvents.player_ready_to_choose_action.emit()

		return

	
	if player.will_be_assassinated:
		GameEvents.do_opponent_assassinate_vfx.emit()
		await get_tree().create_timer(3).timeout
		GameEvents.requested_new_in_battle_notification.emit(player.player_name, null, 'was assassinated and skips thier turn', '')
		is_turn_ended = true
		return

	if player.will_be_robbed:
		var count = GameData.current_battle.opponent_player.gold_count
		GameEvents.do_player_steal_vfx.emit(count)
		GameEvents.requested_player_rob_player.emit(GameData.current_battle.opponent_player, player)
		await get_tree().create_timer(3).timeout

	player.has_taken_turn = false
	player.will_be_assassinated = false
	player.will_be_robbed = false
	player.can_play_district_card = true
	player.can_use_character_ability = true
	player.character_avatar_visible = true
	player.is_picking_action = true
	player.in_play_districts_can_be_targeted = true


	await get_tree().create_timer(3).timeout
	
	GameEvents.player_ready_to_choose_action.emit()


func exit() -> void:
	trigger_end_of_turn_abilities()

	# Loop through all signals defined in GameEvents
	for signal_info in GameEvents.get_signal_list():
		var signal_name = signal_info.name
		# Check if this signal is connected to any method in this script
		for method in self.get_method_list():
			var method_name = method.name
			if GameEvents.is_connected(signal_name, Callable(self, method_name)):
				GameEvents.disconnect(signal_name, Callable(self, method_name))
	GameData.current_battle.real_player.has_taken_turn = true
	GameData.current_battle.real_player.can_play_district_card = false


func process_frame(_delta : float) -> State:
	if not is_turn_ended:
		return null
	else:
		if GameData.current_battle.opponent_player.has_taken_turn:
			return end_of_round_state
		else:
			return opponent_turn_state


func update_possible_character_targets() -> void:
	if player.is_king:
		pass
	pass


func _on_end_player_turn(_player : Player) ->  void:
	is_turn_ended = true
	

func _on_player_picked_district_card_to_keep(_player : Player, card_to_keep : DistrictData, card_to_discard : DistrictData) -> void:
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
	
	GameEvents.requested_append_card_in_player_hand.emit(player, _card_to_keep)
	_card_to_keep.global_position = Vector3(0, 0, -1)
#	GameData.current_battle.real_player.district_cards_in_hand += [_card_to_keep.resource]
	


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

	
	GameEvents.requested_append_card_in_player_discard.emit(player, _card_to_discard)
	_card_to_discard.global_position = Vector3(0, 0, -1)
	
	player.is_picking_action = false


func _on_in_battle_action_selected(action : Callable) -> void:
	action.call()
	GameData.current_battle.real_player.is_picking_action = false


func _on_player_played_district_card(card : DistrictData) -> void:
	var current_gold = player.gold_count
	player.gold_count = current_gold - card.cost
	
	GameEvents.player_spent_gold.emit(player, card.cost)
	
	player.districts_played_this_turn += 1
	player.district_cards_in_play += [card]


func trigger_end_of_turn_abilities() -> void:
	for card in player.district_cards_in_play:
		if card.ability_script and card.ability_script.has_method("on_end_of_turn"):
			card.ability_script.on_end_of_turn(card, player)


func _on_player_chose_action(_player : Player):
	if _player != player:
		return

	if not player.will_be_assassinated:
		return

	GameEvents.do_opponent_assassinate_vfx.emit()
	await get_tree().create_timer(3).timeout
	GameEvents.requested_new_in_battle_notification.emit(player.player_name, null, 'was assassinated and skips thier turn', '')
	is_turn_ended = true
