extends Control
class_name GameUI


func _ready() -> void:
	GameEvents.ready_to_exclude_characters.connect(_on_ready_to_exclude_characters)


func _on_ready_to_exclude_characters() -> void:
	var instance = GameConstants.CHARACTER_CARD_CONTROLLER_SCENE.instantiate()
	add_child(instance)
