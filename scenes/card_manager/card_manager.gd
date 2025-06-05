extends Node2D
class_name CardManager

const CARD_COLLISION_MASK : int = 1
const CARD_SLOT_COLLISION_MASK : int = 2

var player_hand : PlayerHand
var card_being_dragged : DistrictCard
var is_hovering_on_card :  bool = false
var window_size : Vector2


func _ready() -> void:
	window_size = get_viewport().size
	player_hand = get_tree().get_first_node_in_group("player_hand")

	GameEvents.connect("left_mouse_button_pressed", _on_left_mouse_button_pressed)
	GameEvents.connect("left_mouse_button_released", _on_left_mouse_button_released)


func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_position = get_global_mouse_position()
		var destination_position = Vector2(clamp(mouse_position.x, 0, window_size.x), clamp(mouse_position.y, 0, window_size.y))
		var tween = get_tree().create_tween()
		tween.tween_property(card_being_dragged, "position", destination_position, 0.2 )
		

func _on_left_mouse_button_pressed() -> void:
	pass


func _on_left_mouse_button_released() -> void:
	if card_being_dragged:
		card_stop_drag()


func raycast_check_for_card() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var paramters = PhysicsPointQueryParameters2D.new()
	paramters.position = get_global_mouse_position()
	paramters.collide_with_areas = true
	paramters.collision_mask = CARD_COLLISION_MASK
	var result = space_state.intersect_point(paramters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	else: 
		return null


func raycast_check_for_card_slot() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var paramters = PhysicsPointQueryParameters2D.new()
	paramters.position = get_global_mouse_position()
	paramters.collide_with_areas = true
	paramters.collision_mask = CARD_SLOT_COLLISION_MASK
	var result = space_state.intersect_point(paramters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else: 
		return null


func get_card_with_highest_z_index(cards : Array) -> DistrictCard:
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in cards.size():
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = cards[i].collider.get_parent()
			highest_z_index = current_card.z_index
	return highest_z_card


func card_start_drag(card : DistrictCard) -> void:
	card_being_dragged = card
	#card_being_dragged.scale = Vector2(1.0, 1.0)
	card_being_dragged.is_being_dragged = true
	#card_being_dragged.start_is_draggin_animation()


func card_stop_drag(_delta = null) -> void:
	player_hand = get_tree().get_first_node_in_group("player_hand")

	var card_slot_found = raycast_check_for_card_slot() as CardSlot
	
	if card_slot_found and not card_slot_found.card_in_slot:
		player_hand.remove_card_from_hand(card_being_dragged)
		var tween = get_tree().create_tween()
		tween.tween_property(card_being_dragged, "position", card_slot_found.position, 0.2 )
		card_being_dragged.disable_collider()
		card_slot_found.card_in_slot = true
		card_being_dragged.is_in_card_slot = true
		card_being_dragged.scale = Vector2(0.7, 0.7)
	else:
		player_hand.swap_card_positions(card_being_dragged)
		player_hand.add_card_to_hand(card_being_dragged)
		
	card_being_dragged.is_being_dragged = false
	#card_being_dragged.reverse_is_draggin_animation()
	card_being_dragged = null
