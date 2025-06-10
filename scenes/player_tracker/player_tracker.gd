extends Control
class_name PlayerTracker


@export var player : Player
@export var is_king : bool = false
@export var avatar_texture : Texture = preload("res://assets/avatars/Icon1.png")


func _ready() -> void:
	GameEvents.player_data_changed.connect(_on_player_data_changed)
	
	set_card_count(player.district_cards_in_hand_count)
	set_gold_count(player.gold_count)
	set_district_count(player.districts_built_count)
	set_avatar_texture(player.avatar_texture)
	set_king_crown(player.is_king)


func _on_player_data_changed() -> void:
	for p in GameData.players:
		if p == player:
			#print(p.district_cards_in_hand_count)
			set_card_count(p.district_cards_in_hand_count)
			set_gold_count(p.gold_count)
			set_district_count(p.districts_built_count)
			set_avatar_texture(p.avatar_texture)
			set_king_crown(p.is_king)
			set_player_taking_turn()
			add_character_card_to_slot()


func set_card_count(new_count : int) -> void:
	$Sprites/CardCountLabel.text = str(new_count)


func set_gold_count(new_count : int) -> void:
	$Sprites/GoldCountLabel.text = str(new_count)


func set_district_count(new_count : int) -> void:
	$Sprites/DistrictCountLabel.text = str(new_count)


func set_player_taking_turn() -> void:
	if player == GameData.current_player:
		play_taking_turn()
	else:
		$AnimationPlayer.play("RESET")


func set_avatar_texture(new_texture : Texture2D) -> void:
	$Sprites/AvatarSprite.texture = new_texture


func set_king_crown(is_king : bool) -> void:
	if is_king:
		$Sprites/KingCrownSprite.visible = true


func scale_up() -> void:
	$AnimationPlayer.play("scale_up")


func play_taking_turn() -> void:
	$AnimationPlayer.play("taking_turn")


func add_character_card_to_slot() -> void:
	if $CharacterCardSlot.get_children().size() > 0:
		return
	if not player.current_character_card:
		return 
	var card = GameConstants.CHARACTER_CARD_SCENE.instantiate()
	$CharacterCardSlot.add_child(card)
	card.scale = Vector2(0.5, 0.5)
	card.character_resource = player.current_character_card
	card.is_controlled_by_player = true
	card.set_character()
