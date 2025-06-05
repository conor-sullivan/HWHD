extends Control
class_name PlayerTracker


@export var player : Player
@export var is_king : bool = false
@export var avatar_texture : Texture = preload("res://assets/avatars/Icon1.png")


func _ready() -> void:
	GameEvents.player_data_changed.connect(_on_player_data_changed)
	
	if player:
		set_card_count(player.district_cards_in_hand_count)
		set_gold_count(player.gold_count)
		set_district_count(player.districts_built_count)
		set_avatar_texture(player.avatar_texture)
		set_king_crown(player.is_king)


func _on_player_data_changed() -> void:
	var players : Array[Player] = get_tree().get_first_node_in_group("game_manager").players
	for p in players:
		if p == player:
			print(p.district_cards_in_hand_count)
			set_card_count(p.district_cards_in_hand_count)
			set_gold_count(p.gold_count)
			set_district_count(p.districts_built_count)
			set_avatar_texture(p.avatar_texture)
			set_king_crown(p.is_king)


func set_card_count(new_count : int) -> void:
	$CardCountLabel.text = str(new_count)


func set_gold_count(new_count : int) -> void:
	$GoldCountLabel.text = str(new_count)


func set_district_count(new_count : int) -> void:
	$DistrictCountLabel.text = str(new_count)


func set_avatar_texture(new_texture : Texture2D) -> void:
	$AvatarSprite.texture = new_texture


func set_king_crown(is_king : bool) -> void:
	if is_king:
		$KingCrownSprite.visible = true


func scale_up() -> void:
	$AnimationPlayer.play("scale_up")


func play_taking_turn() -> void:
	$AnimationPlayer.play("taking_turn")
