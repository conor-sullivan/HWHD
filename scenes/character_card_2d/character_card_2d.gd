class_name CharacterCard2D
extends Control

@export var shader_material : Material
@export var is_target_for_ability : bool = false
@export var is_selected_card : bool = false
@export var is_face_up : bool = false 


var data : CharacterData : 
	set(_data):
		if _data:
			data = _data
			%FrontSprite.texture = _data.avatar_texture


func _ready() -> void:
	GameEvents.players_character_card_selected.connect(_on_players_character_card_selected)


func enable_collision() -> void:
	$Panel/Area2D/CollisionShape2D.disabled = false


func show_front() -> void:
	is_face_up = true
	%FrontSprite.show()


func show_shader() -> void:
	%Shader.show()


func tween_selected() -> void:
	var size_tween : Tween = create_tween()
	size_tween.set_ease(Tween.EASE_IN_OUT)
	size_tween.set_trans(Tween.TRANS_CUBIC)
	size_tween.tween_property($".", "scale", Vector2.ONE * 1.5, 0.2)
	size_tween.set_ease(Tween.EASE_IN_OUT)
	size_tween.set_trans(Tween.TRANS_CUBIC)
	size_tween.tween_property($".", "scale", Vector2.ZERO, 0.2)


func tween_not_selected() -> void:
	var size_tween : Tween = create_tween()
	size_tween.set_ease(Tween.EASE_IN_OUT)
	size_tween.set_trans(Tween.TRANS_CUBIC)
	size_tween.tween_property($".", "scale", Vector2.ZERO, 0.2)
	
	await get_tree().create_timer(0.5).timeout
	if is_target_for_ability: return
	call_deferred("queue_free")


func _on_mouse_entered() -> void:
	if not is_face_up:
		return
	var size_tween : Tween = create_tween()
	size_tween.set_ease(Tween.EASE_IN_OUT)
	size_tween.set_trans(Tween.TRANS_CUBIC)
	size_tween.tween_property($".", "scale", Vector2.ONE * 1.1, 0.2)
	
	(CharacterPopups as CharacterCardPopupsHandler).item_popup(Rect2i (Vector2i(global_position), Vector2i(size) ), data)


func _on_mouse_exited() -> void:
	if not is_face_up:
		return
	var size_tween : Tween = create_tween()
	size_tween.set_ease(Tween.EASE_IN_OUT)
	size_tween.set_trans(Tween.TRANS_CUBIC)
	size_tween.tween_property($".", "scale", Vector2.ONE, 0.2)
	(CharacterPopups as CharacterCardPopupsHandler).hide_item_popup()


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_selected_card = true
			tween_selected()
			GameEvents.players_character_card_selected.emit(data)
			await get_tree().create_timer(0.5).timeout
			if is_target_for_ability: return
			call_deferred("queue_free")


func reset_tween() -> void:
	var size_tween : Tween = create_tween()
	size_tween.set_ease(Tween.EASE_IN_OUT)
	size_tween.set_trans(Tween.TRANS_CUBIC)
	size_tween.tween_property($".", "scale", Vector2.ONE, 0.2)
	

func _on_players_character_card_selected(_character : CharacterData) -> void:
	if not is_selected_card:
		tween_not_selected()
