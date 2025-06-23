class_name HUD
extends CanvasLayer

var gold_icon_scene : PackedScene = preload("res://scenes/gold_coin_icon/gold_coin_icon.tscn")
var character_avatar_visible : bool = false

func _ready() -> void:
	GameEvents.player_gained_gold.connect(_on_player_gained_gold)
	GameEvents.player_spent_gold.connect(_on_player_spent_gold)
	
	
func _on_player_spent_gold(player: Player, _count : int) -> void:
	if player.is_computer:
		var coins = %OpponentGoldBoxContainer.get_children()
		%OpponentGoldBoxContainer.remove_child(coins[-1])
	elif not player.is_computer:
		var coins = %PlayerGoldBoxContainer.get_children()
		%PlayerGoldBoxContainer.remove_child(coins[-1])

	

func _on_player_gained_gold(player : Player) -> void:
	var instance = gold_icon_scene.instantiate()

	if player.is_computer:
		%OpponentGoldBoxContainer.add_child(instance)
	elif not player.is_computer:
		%PlayerGoldBoxContainer.add_child(instance)


func _on_opponent_area_2d_mouse_entered() -> void:
	if not character_avatar_visible:
		return
	
	(CharacterPopups).item_popup(null, GameData.current_battle.opponent_player.current_character_card)

func _on_opponent_area_2d_mouse_exited() -> void:
	if not character_avatar_visible:
		return
	
	(CharacterPopups).hide_item_popup()
