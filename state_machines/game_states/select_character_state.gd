extends State
class_name SelectCharacterState

@export var player_turn_scene : State

var all_characters_chosen : bool = false


func _ready() -> void:
	GameEvents.character_card_chosen_by_player.connect(_on_character_card_chosen_by_player)


func enter() -> void:
	print("select character state")


func process_frame(_delta : float) -> State:
	if all_characters_chosen:
		print("all chosen")
		return player_turn_scene
	else:
		return null


func _on_character_card_chosen_by_player(card : CharacterData) -> void:
	GameData.current_player.has_chosen_character_card = true
	GameData.current_player.current_character_card = card
	GameEvents.player_turn_changed.emit()
	
	all_characters_chosen = true
	
	for player in GameData.players:
		if not player.has_chosen_character_card:
			all_characters_chosen = false
