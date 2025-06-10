extends Node
class_name AIController

# listen for signal to chose character card randomly
func _ready() -> void:
	GameEvents.requested_ai_to_choose_character.connect(_on_requested_ai_to_choose_character)


func _on_requested_ai_to_choose_character() -> void:
	print("ai requested to pick a character")
	if not GameData.current_player.is_computer:
		return
	
	await wait_random_time()
	GameEvents.requested_to_pick_random_character_card.emit()


func wait_random_time() -> void:
	$Timer.wait_time = randi_range(3, 7)
	$Timer.start()
	await $Timer.timeout
