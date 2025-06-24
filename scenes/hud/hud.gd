class_name HUD
extends CanvasLayer

@export var missing_avatar_texture : Texture
@export var unknown_avatar_texture : Texture

var gold_icon_scene : PackedScene = preload("res://scenes/gold_coin_icon/gold_coin_icon.tscn")

func _ready() -> void:
	GameEvents.all_character_cards_chosen.connect(_on_all_character_cards_chosen)
	GameEvents.player_data_changed.connect(_on_player_data_changed)
	GameEvents.player_gained_gold.connect(_on_player_gained_gold)
	GameEvents.player_spent_gold.connect(_on_player_spent_gold)


func update_character_avatars() -> void:
	if not GameData.current_battle:
		return
	var real_player = GameData.current_battle.real_player
	var opponent = GameData.current_battle.opponent_player
	if real_player.character_avatar_visible:
		print('yes')
		%PlayerAbilityAvatar.texture = real_player.current_character_card.small_avatar
	if opponent.character_avatar_visible:
		%OpponentAbilityAvatar.texture = opponent.current_character_card.small_avatar
	
	if real_player.can_use_character_ability:
		%PlayerAbilityShader.show()
	else:
		%PlayerAbilityShader.hide()
	
	if opponent.can_use_character_ability:
		%OpponentAbilityShader.show()
	else:
		%OpponentAbilityShader.hide()


func _on_player_data_changed() -> void:
	update_character_avatars()

	
func _on_player_spent_gold(player: Player, count : int) -> void:
	for c in count:
		if player.is_computer:
			var coins = %OpponentGoldBoxContainer.get_children()
			%OpponentGoldBoxContainer.remove_child(coins[-1])
		elif not player.is_computer:
			var coins = %PlayerGoldBoxContainer.get_children()
			%PlayerGoldBoxContainer.remove_child(coins[-1])



func _on_player_gained_gold(player : Player, count : int) -> void:
	var instance = gold_icon_scene.instantiate()
	for c in count:
		if player.is_computer:
			%OpponentGoldBoxContainer.add_child(instance)
		elif not player.is_computer:
			%PlayerGoldBoxContainer.add_child(instance)


func _on_opponent_area_2d_mouse_entered() -> void:
	if not GameData.current_battle.opponent_player.character_avatar_visible:
		return
	
	CharacterPopups.item_popup(null, GameData.current_battle.opponent_player.current_character_card)
	
func _on_opponent_area_2d_mouse_exited() -> void:
	if not GameData.current_battle.opponent_player.character_avatar_visible:
		return
	
	CharacterPopups.hide_item_popup()


func _on_ability_avatar_sprite_2d_mouse_entered() -> void:
	CharacterPopups.item_popup(null, GameData.current_battle.real_player.current_character_card)


func _on_ability_avatar_sprite_2d_mouse_exited() -> void:
	CharacterPopups.hide_item_popup()


func _on_all_character_cards_chosen() -> void:
	print('chosen')
	# set avatars texture to ???
	%PlayerAbilityAvatar.texture = unknown_avatar_texture
	%OpponentAbilityAvatar.texture = unknown_avatar_texture
