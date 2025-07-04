class_name HUD
extends CanvasLayer

@export var missing_avatar_texture : Texture
@export var unknown_avatar_texture : Texture

var gold_icon_scene : PackedScene = preload("res://scenes/gold_coin_icon/gold_coin_icon.tscn")

func _ready() -> void:
	GameEvents.started_player_turn_state.connect(_on_started_player_turn_state)
	GameEvents.all_character_cards_chosen.connect(_on_all_character_cards_chosen)
	GameEvents.player_data_changed.connect(_on_player_data_changed)
	GameEvents.player_gained_gold.connect(_on_player_gained_gold)
	GameEvents.player_spent_gold.connect(_on_player_spent_gold)


func update_character_avatars() -> void:
	if not GameData.current_battle:
		return
		
	var real_player = GameData.current_battle.real_player
	var opponent = GameData.current_battle.opponent_player
	
	set_king_crowns(real_player, opponent)
	set_ability_shader(real_player, opponent)
	set_ability_avatar(real_player, opponent)


func set_ability_avatar(real_player : Player, opponent : Player) -> void:
	if real_player.character_avatar_visible:
		%PlayerAbilityAvatar.texture = real_player.current_character_card.small_avatar
	if opponent.character_avatar_visible:
		%OpponentAbilityAvatar.texture = opponent.current_character_card.small_avatar


func set_ability_shader(real_player : Player, opponent : Player) -> void:
	if real_player.can_use_character_ability:
		%PlayerAbilityShader.show()
	else:
		%PlayerAbilityShader.hide()
	
	if opponent.can_use_character_ability:
		%OpponentAbilityShader.show()
	else:
		%OpponentAbilityShader.hide()


func set_king_crowns(real_player : Player, opponent : Player) -> void:
	if real_player.is_king:
		%PlayerKingCrown.show()
	else:
		%PlayerKingCrown.hide()
	
	if opponent.is_king:
		%OpponentKingCrown.show()
	else:
		%OpponentKingCrown.hide()


func set_turn_indicator() -> void:
	if not GameData.current_battle:
		return
	if not GameData.current_battle.current_players_turn:
		return
	if GameData.current_battle.current_players_turn.is_computer:
		%OpponentTurnIndicator.show()
		%EndTurnIndicator.hide()
	else:
		%OpponentTurnIndicator.hide()
		%EndTurnIndicator.show()


func _on_player_data_changed() -> void:
	update_character_avatars()
	set_turn_indicator()

	
func _on_player_spent_gold(player: Player, count : int) -> void:
	for c in count:
		if player.is_computer:
			var coins = %OpponentGoldBoxContainer.get_children()
			%OpponentGoldBoxContainer.remove_child(coins[-1])
		elif not player.is_computer:
			var coins = %PlayerGoldBoxContainer.get_children()
			%PlayerGoldBoxContainer.remove_child(coins[-1])



func _on_player_gained_gold(player : Player, count : int) -> void:
	for c in count:
		var instance = gold_icon_scene.instantiate()
		if player.is_computer:
			%OpponentGoldBoxContainer.add_child(instance)
		elif not player.is_computer:
			%PlayerGoldBoxContainer.add_child(instance)
		if count > 1:
			await get_tree().create_timer(0.1).timeout


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
	# set avatars texture to ???
	%PlayerAbilityAvatar.texture = unknown_avatar_texture
	%OpponentAbilityAvatar.texture = unknown_avatar_texture


func _on_started_player_turn_state() -> void:
	await get_tree().create_timer(0.5).timeout
	if GameData.current_battle.current_players_turn.is_computer:
		%Notification.text = "Opponent has the initiative..."
	else:
		%Notification.text = "You have the initiative!"
	$AnimationPlayer.play("show_notification")


func _on_player_ability_avatar_gui_input(event: InputEvent) -> void:
	if not GameData.current_battle.real_player.can_use_character_ability:
		return
	if event is InputEventMouseButton:
		var button = event.button_index
		var pressed = event.pressed
		if button == 1 and pressed == true:
			if GameData.current_battle.real_player.character_avatar_visible:
				var character = GameData.current_battle.real_player.current_character_card
				var ability = load(character.ability_function_path).new()
				if ability:
					ability.player_do_ability()


func _on_end_turn_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var button = event.button_index
		var pressed = event.pressed
		if button == 1 and pressed == false:
			GameEvents.end_player_turn.emit(GameData.current_battle.real_player)
