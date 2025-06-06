extends State
class_name ExcludeCharactersState

@export var select_character_state : State

var ready_for_first_player_to_choose_character : bool = false


func _ready() -> void:
	GameEvents.ready_for_first_player_to_choose_character.connect(_on_ready_for_first_player_to_choose_character)


func enter() -> void:
	GameEvents.ready_to_exclude_characters.emit()


func process_frame(delta : float) -> State:
	if ready_for_first_player_to_choose_character:
		return select_character_state
	else:
		return null


func _on_ready_for_first_player_to_choose_character() -> void:
	ready_for_first_player_to_choose_character = true
