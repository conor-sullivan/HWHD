extends Node2D
class_name PlayerHand

const CARD_WIDTH : int = 120
const HAND_Y_POSITION : int = 550
const MAX_HAND_WIDTH : int = 600
const CARD_SWAP_POSITION_LIMIT : int = 700
const DEFAULT_CARD_MOVE_SPEED : float = 0.2

var player_hand : Array[DistrictCard] = []
var center_screen_x : float


func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	GameEvents.card_hovered.connect(_on_card_hovered)
	GameEvents.card_hovered_off.connect(_on_card_hovered_off)


func _physics_process(delta: float) -> void:
	pass#make_room_for_card_swap()


func _on_card_hovered(hovered_over_card : DistrictCard, card_doing_the_hovering : DistrictCard) -> void:
	make_room_for_card_swap(hovered_over_card, card_doing_the_hovering)


func _on_card_hovered_off(hovered_over_card : DistrictCard, card_doing_the_hovering : DistrictCard) -> void:
	make_room_for_card_swap(hovered_over_card, card_doing_the_hovering)



func add_card_to_hand(card : DistrictCard, speed : float = DEFAULT_CARD_MOVE_SPEED) -> void:
	if card not in player_hand:
		player_hand.insert(0, card)
	
	update_hand_positions(speed)


func update_hand_positions(speed : float = DEFAULT_CARD_MOVE_SPEED) -> void:
	for i in range(player_hand.size()):
		move_child(player_hand[i -1], i - 1)
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i] as DistrictCard
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position, speed)


func calculate_card_position(index : int) -> float:
	var total_width = player_hand.size() * CARD_WIDTH
	var card_seperation = CARD_WIDTH
	
	if total_width > MAX_HAND_WIDTH:
		card_seperation = MAX_HAND_WIDTH / float(player_hand.size())
		total_width = player_hand.size() * card_seperation
		
	var x_offset = center_screen_x + (card_seperation/2.0) + (index * card_seperation) - total_width / 2.0
	return x_offset


func animate_card_to_position(card : DistrictCard, new_position : Vector2, speed : float = DEFAULT_CARD_MOVE_SPEED) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed )


func remove_card_from_hand(card : DistrictCard) -> void:
	player_hand.erase(card)
	update_hand_positions()


func make_room_for_card_swap(hovered_over_card : DistrictCard, card_doing_the_hovering : DistrictCard) -> void:
#	if card_doing_the_hovering.position.y < CARD_SWAP_POSITION_LIMIT: return 
	var selected_card_index = player_hand.find(card_doing_the_hovering)

	for card in player_hand:
		if card_doing_the_hovering.global_position.x < card.global_position.x:
			var card_index = player_hand.find(card)
			if selected_card_index > card_index:
				do_swap(card_doing_the_hovering, selected_card_index, card, card_index)
				
	var reverse_order_cards = player_hand.duplicate()
	reverse_order_cards.reverse()
	
	for card in reverse_order_cards:
		if card_doing_the_hovering.global_position.x > card.global_position.x:
			var card_index = player_hand.find(card)
			if selected_card_index < card_index:
				do_swap(card_doing_the_hovering, selected_card_index, card, card_index)
	
	for i in range(player_hand.size()):
		move_child.call_deferred(player_hand[i -1], i - 1)
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i] as DistrictCard
		card.position_in_hand = new_position
		#if card == card_doing_the_hovering: continue

		animate_card_to_position(card, new_position, DEFAULT_CARD_MOVE_SPEED)



func swap_card_positions(selected_card : DistrictCard) -> void:
	if selected_card.position.y < CARD_SWAP_POSITION_LIMIT: return 
	var selected_card_index = player_hand.find(selected_card)

	for card in player_hand:
		if selected_card.global_position.x < card.global_position.x:
			var card_index = player_hand.find(card)
			if selected_card_index > card_index:
				do_swap(selected_card, selected_card_index, card, card_index)
				
	var reverse_order_cards = player_hand.duplicate()
	reverse_order_cards.reverse()
	
	for card in reverse_order_cards:
		if selected_card.global_position.x > card.global_position.x:
			var card_index = player_hand.find(card)
			if selected_card_index < card_index:
				do_swap(selected_card, selected_card_index, card, card_index)
	
	update_hand_positions()


func do_swap(selected_card : DistrictCard, selected_card_index : int, card : DistrictCard, card_index : int) -> void:
	var buffer = player_hand[selected_card_index]
	var buffer_pos = selected_card.position_in_hand
	
	player_hand[selected_card_index] = player_hand[card_index]
	selected_card.position_in_hand = card.position_in_hand
	player_hand[card_index] = buffer
	card.position_in_hand = buffer_pos
