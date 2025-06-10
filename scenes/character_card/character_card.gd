extends Control
class_name CharacterCard

@export var character_resource : CharacterData

var is_controlled_by_player : bool = false
var is_face_down_card : bool = false

enum CardBackgroundRegionX {
	Blue = 0,
	Red = 119,
	Gray = 236,
	Green = 352,
	Gold = 467
}


func _ready() -> void:
	GameEvents.requested_character_take_turn.connect(_on_requested_character_take_turn)
	set_character()


func set_character() -> void:
	set_card_background(get_card_background_region_x(character_resource.color))
	set_character_name(character_resource.character_name)
	set_play_order_number(character_resource.play_order_number)
	set_avatar_sprite(character_resource.avatar_texture)


func _on_requested_character_take_turn(_character_resource : CharacterData) -> void:
	if _character_resource != character_resource:
		return
	if is_controlled_by_player:
		print("yes")
		$AnimationPlayer.play("reveal_flip")


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
	enable_collider()


func play_hide_flip_animation() -> void:
	$AnimationPlayer.play_backwards("reveal_flip")
	await $AnimationPlayer.animation_finished
	disable_collider()
	

func shrink_scale() -> void:
	$AnimationPlayer.play("shrink_scale")


func play_waiting_to_pick() -> void:
	$AnimationPlayer.play("waiting_to_pick")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			set_card_as_picked()


func set_card_as_picked() -> void:
	$AnimationPlayer.play("picked")
	await $AnimationPlayer.animation_finished
	GameEvents.character_card_chosen_by_player.emit(character_resource)


func enable_collider() -> void:
	$Area2D/CollisionShape2D.disabled = false


func disable_collider() -> void:
	$Area2D/CollisionShape2D.disabled = true


func _on_area_2d_mouse_entered() -> void:
	GameEvents.on_character_card_hovered_on.emit(self)
	scale = Vector2(1.3, 1.3)

func _on_area_2d_mouse_exited() -> void:
	GameEvents.on_character_card_hovered_off.emit(self)
	scale = Vector2(1.0, 1.0)
