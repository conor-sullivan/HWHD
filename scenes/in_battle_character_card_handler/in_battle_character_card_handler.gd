class_name InBattleCharacterCardHandler
extends Control

enum HandlerState {
	Excluding, Picking
}

var known_excluded_characters : Array[CharacterData]
var current_state : HandlerState
var number_of_card_choices : int
var character_choices : Array[CharacterData]
var character_card_scene : PackedScene = preload("res://scenes/character_card_2d/character_card_2d.tscn")
#var deck : Array[CharacterData]
var position_tween : Tween
var move_tween_duration : float = 0.4

var five_card_positions : Array[Vector2] = [
	Vector2(126.0, 324.0),
	Vector2(351.0, 324.0),
	Vector2(576.0, 324.0),
	Vector2(801.0, 324.0),
	Vector2(1026.0, 324.0)
]

var three_card_positions : Array[Vector2] = [
	Vector2(351.0 - 50, 324.0),
	Vector2(576.0, 324.0),
	Vector2(801.0 + 50, 324.0)
]

var two_card_positions : Array[Vector2] = [
	Vector2(451.0 - 50, 324.0),
	Vector2(701.0 + 50, 324.0)
]


func _ready() -> void:
	GameEvents.players_character_card_selected.connect(_on_players_character_card_selected)
	GameEvents.starting_excluded_characters_state.connect(_on_starting_excluded_characters_state)
	GameEvents.starting_select_character_state.connect(_on_starting_select_character_state)
	GameEvents.requested_show_in_battle_character_card_handler_overlay.connect(_on_requested_show_in_battle_character_card_handler_overlay)
	GameEvents.requested_draw_character_card.connect(_on_requested_draw_character_card)
	GameEvents.done_drawing_initial_character_cards.connect(_on_done_drawing_initial_character_cards)
	GameEvents.done_drawing_available_character_cards.connect(_on_done_drawing_available_character_cards)


func _on_players_character_card_selected(_card : CharacterData) -> void:
	await get_tree().create_timer(0.4).timeout
	hide()
	for child in get_children():
		if child is CharacterCard2D:
			child.queue_free()
#			deck = []


func _on_done_drawing_available_character_cards() -> void:
	for child in get_children():
		if child is CharacterCard2D:
			character_choices.append(child.data)
	
	print('here ', character_choices)
	GameEvents.character_choices_provided.emit(character_choices)


func _on_starting_select_character_state(number_of_cards : int) -> void:
	for child in get_children():
		if child is CharacterCard2D:
			child.queue_free()
			
	$Button.hide()
	
	known_excluded_characters = []
	
	if GameData.current_battle.real_player.is_king:
		%Notification.text = "King has first choice!\nChoose your character for this round"
	else:
		%Notification.text = "You get second choice\nChoose your character for this round"
	
	current_state = HandlerState.Picking
	number_of_card_choices = number_of_cards


func _on_starting_excluded_characters_state() -> void:
	current_state = HandlerState.Excluding


func _on_done_drawing_initial_character_cards() -> void:
	update_known_excluded_characters_in_player_data()
	
	await get_tree().create_timer(0.5).timeout
	var size_tween = create_tween()
	
	$Button.scale = Vector2.ZERO
	$Button.show()
	
	size_tween.set_ease(Tween.EASE_OUT)
	size_tween.set_trans(Tween.TRANS_SPRING)
	size_tween.tween_property($Button, "scale", Vector2.ONE / 2, 0.5)



func _on_requested_show_in_battle_character_card_handler_overlay() -> void:
#	deck = GameData.current_battle.character_cards
	show()



func _on_requested_draw_character_card(face_down : bool) -> void:
	GameData.current_battle.character_cards.shuffle()
	
	var character_card = GameData.current_battle.character_cards[0] as CharacterData
	var instance = character_card_scene.instantiate() as CharacterCard2D
	
	instance.data = character_card
	instance.global_position = Vector2.ZERO

	if not face_down:
		instance.show_front()
		known_excluded_characters.append(character_card)
	
	var card_number : int
	var pos : Vector2
	
	if current_state == HandlerState.Excluding:
		card_number = (8 - GameData.current_battle.character_cards.size())
		pos = five_card_positions[card_number]
	elif current_state == HandlerState.Picking:
		instance.enable_collision()
		instance.show_shader()
		
		card_number = number_of_card_choices - GameData.current_battle.character_cards.size()
		
		match number_of_card_choices:
			2 : pos = two_card_positions[card_number]
			3:  pos = three_card_positions[card_number]
	
	animate_to_position(instance, pos)
	add_child(instance)

	GameData.current_battle.character_cards.erase(character_card)


func update_known_excluded_characters_in_player_data() -> void:
	for player in GameData.current_battle.players:
		player.known_excluded_characters = known_excluded_characters


func _tween_card_position(card : CharacterCard2D, pos: Vector2, duration: float):
	position_tween.tween_property(card, "global_position", pos, duration)


func animate_to_position(card : CharacterCard2D, new_position: Vector2, duration = move_tween_duration):
	position_tween = create_tween()
	position_tween.set_ease(Tween.EASE_OUT)
	position_tween.set_trans(Tween.TRANS_BOUNCE)
	_tween_card_position(card, new_position, duration)
	return position_tween


func _on_button_pressed() -> void:
	if current_state == HandlerState.Excluding:
		GameEvents.accepted_character_cards.emit()
