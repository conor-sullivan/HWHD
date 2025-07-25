class_name OpponentShield extends Node3D

func _ready() -> void:
	GameEvents.toggle_shield.connect(_on_toggle_shield)


func _on_toggle_shield(player: Player, shielded: bool) -> void:
	if player == GameData.current_battle.opponent_player:
		visible = shielded
	
		toggle_tween()


func toggle_tween() -> void:
	if not visible:
		return

	scale = Vector3(0.0, 0.0, 0.0)  

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)

	tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.6)

	GameEvents.requested_camera_shake.emit(0.2, 0.2)
