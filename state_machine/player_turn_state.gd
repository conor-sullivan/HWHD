class_name PlayerTurnState
extends State

@export var opponent_turn_state : State
@export var end_of_round_state : State

var player : Player
var is_turn_ended : bool = false


func enter() -> void:
	print('player turn state')
	GameEvents.end_player_turn.connect(_on_end_player_turn)
	GameEvents.in_battle_action_selected.connect(_on_in_battle_action_selected)
	GameEvents.player_played_district_card.connect(_on_player_played_district_card)
	GameEvents.started_player_turn_state.emit()
	GameEvents.player_picked_district_card_to_keep.connect(_on_player_picked_district_card_to_keep)
	
	player = GameData.current_battle.real_player
	GameData.current_battle.current_players_turn = player 
	player.can_play_district_card = true
	player.can_use_character_ability = true
	player.character_avatar_visible = true
	player.is_picking_action = true
	
	await get_tree().create_timer(3).timeout
	
	GameEvents.player_ready_to_choose_action.emit()


func exit() -> void:
	for connection in get_incoming_connections():
		disconnect(connection.signal.get_name(), connection.callable)
	GameData.current_battle.current_players_turn.has_taken_turn = true


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
	GameData.current_battle.real_player.district_cards_in_hand += [_card_to_keep.resource]
	


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
