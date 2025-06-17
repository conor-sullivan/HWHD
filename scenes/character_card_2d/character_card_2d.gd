class_name CharacterCard2D
extends Control

@export var shader_material : Material

var data : CharacterData : 
	set(_data):
		if _data:
			data = _data
			$FrontSprite.texture = _data.avatar_texture


func show_front() -> void:
	$FrontSprite.show()


func show_shader() -> void:
	$FrontSprite.material = shader_material
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			GameEvents.players_character_card_selected.emit(data)
