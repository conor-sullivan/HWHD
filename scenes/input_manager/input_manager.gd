extends Node2D
class_name InputManager

signal left_mouse_button_pressed
signal left_mouse_button_released

const CARD_COLLISION_MASK : int = 1
const DECK_COLLISION_MASK : int = 4

var card_manager : CardManager
var deck : DistrictDeck


func _ready() -> void:
	card_manager = get_tree().get_first_node_in_group("card_manager")
	deck = get_tree().get_first_node_in_group("district_deck")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			left_mouse_button_pressed.emit()
			raycast_at_cursor()
		else: 
			left_mouse_button_released.emit()


func raycast_at_cursor() -> void:
	var space_state = get_world_2d().direct_space_state
	var paramters = PhysicsPointQueryParameters2D.new()
	paramters.position = get_global_mouse_position()
	paramters.collide_with_areas = true
	var result = space_state.intersect_point(paramters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == CARD_COLLISION_MASK:
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager.card_start_drag(card_found)
		elif result_collision_mask == DECK_COLLISION_MASK:
			#deck.draw_card()
			pass
