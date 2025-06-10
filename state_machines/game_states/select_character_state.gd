extends State
class_name SelectCharacterState

@export var player_turn_scene : State

var all_characters_chosen : bool = false


func _ready() -> void:
	#GameEvents.ready_to_change_turns.connect(_on_ready_to_change_turns)
	GameEvents.character_card_chosen_by_player.connect(_on_character_card_chosen_by_player)


func enter() -> void:
	pass
	

func process_frame(_delta : float) -> State:
	if all_characters_chosen:
		print("all chosen")
		return player_turn_scene
	else:
		return null


func _on_character_card_chosen_by_player(card : CharacterData) -> void:
	GameData.current_player.has_chosen_character_card = true
	GameData.current_player.current_character_card = card

	
	all_characters_chosen = true
	
	for player in GameData.players:
		if not player.has_chosen_character_card:
			all_characters_chosen = false
	
	GameEvents.player_data_changed.emit()
	GameEvents.ready_to_change_turns.emit()
	
