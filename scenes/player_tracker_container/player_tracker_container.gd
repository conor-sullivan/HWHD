extends HBoxContainer
class_name PlayerTrackerContainer

const PLAYER_TRACKER_SCENE = preload("res://scenes/player_tracker/player_tracker.tscn")


func _ready() -> void:
	GameEvents.player_data_changed.connect(_on_player_data_changed)


func _on_player_data_changed() -> void:
	print("new data ", GameData.current_player.district_cards_in_hand_count)
	if get_children().size() < GameData.players.size():
		for child in get_children():
			child.queue_free()
		
		for player in GameData.players:
			var player_tracker_scene = PLAYER_TRACKER_SCENE.instantiate()
			player_tracker_scene.player = player
			
			add_child(player_tracker_scene)
			
			if player.player_id == GameData.current_player.player_id:
				player_tracker_scene.play_taking_turn()
