extends Control
class_name CharacterCard

@export var character_resource : CharacterData


enum CardBackgroundRegionX {
	Blue = 0,
	Red = 119,
	Gray = 236,
	Green = 352,
	Gold = 467
}


func _ready() -> void:
	set_card_background(get_card_background_region_x(character_resource.color))
	set_character_name(character_resource.character_name)
	set_play_order_number(character_resource.play_order_number)
	set_avatar_sprite(character_resource.avatar_texture)


func set_character_name(character_name : String) -> void:
	$CardFront/NameLabel.text = character_name


func set_play_order_number(number : int) -> void:
	$CardFront/PlayOrderLabel.text = str(number)


func set_card_background(color : float) -> void:
	$CardFront/CardBackgroundSprite.region_rect = Rect2(color, 0.0, 100.0, 128.0)


func set_avatar_sprite(texture : CompressedTexture2D) -> void:
	$CardFront/AvatarSprite.texture = texture


func get_card_background_region_x(color : String) -> float:
	var result = CardBackgroundRegionX.get(color)
	if result != null:
		return CardBackgroundRegionX.get(color)
	else:
		return CardBackgroundRegionX.get("Gray")


func play_place_card_animation() -> void:
	$AnimationPlayer.play("place_card")


func play_reveal_flip_animation() -> void:
	$AnimationPlayer.play("reveal_flip")
	await $AnimationPlayer.animation_finished


func shrink_scale() -> void:
	$AnimationPlayer.play("shrink_scale")


func play_waiting_to_pick() -> void:
	$AnimationPlayer.play("waiting_to_pick")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			GameEvents.character_card_chosen_by_player.emit(character_resource, GameData.current_player.player_id)


func enable_collider() -> void:
	$Area2D/CollisionShape2D.disabled = false


func _on_area_2d_mouse_entered() -> void:
	scale = Vector2(1.3, 1.3)

func _on_area_2d_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)
