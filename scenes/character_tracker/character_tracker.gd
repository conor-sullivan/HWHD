extends Control
class_name CharacterTracker


@export var is_disabled : bool = false
@export var character_resource : CharacterData

 
enum CardBackgroundRegionX {
	Blue = 0,
	Red = 119,
	Gray = 236,
	Green = 352,
	Gold = 467
}


func _ready() -> void:
	if is_disabled:
		$AnimationPlayer.play("disable")
	set_character_name(character_resource.character_name)
	set_card_background(get_card_background_region_x(character_resource.color))
	set_avatar_texture(character_resource.avatar_texture)
	set_play_order_number(character_resource.play_order_number)


func set_character_name(_name : String) -> void:
	$NameLabel.text = _name


func set_card_background(color : float) -> void:
	$CardBackgroundSprite.region_rect = Rect2(color, 0.0, 100.0, 128.0)


func set_avatar_texture(texture : Texture) -> void:
	$AvatarSprite.texture = texture


func set_play_order_number(number : int) -> void:
	$PlayOrderLabel.text = str(number)


func get_card_background_region_x(color : String) -> float:
	var result = CardBackgroundRegionX.get(color)
	#print(result)
	if result != null:
		return CardBackgroundRegionX.get(color)
	else:
		#print("no background region found")
		return CardBackgroundRegionX.get("Gray")
