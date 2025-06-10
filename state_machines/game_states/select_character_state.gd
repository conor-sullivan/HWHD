extends State
class_name SelectCharacterState

@export var player_turn_state : State

var all_characters_chosen : bool = false


func _ready() -> void:
	GameEvents.player_turn_changed.connect(_on_player_turn_changed)
	GameEvents.character_card_chosen_by_player.connect(_on_character_card_chosen_by_player)


func exit() -> void:
	GameEvents.all_characters_picked.emit()


func process_frame(_delta : float) -> State:
	if all_characters_chosen:
		return player_turn_state
	else:
		return null


func _on_character_card_chosen_by_player(card : CharacterData) -> void:
	if get_parent().current_state != self:
		return
	GameData.current_player.has_chosen_character_card = true
	GameData.current_player.current_character_card = card
	
	all_characters_chosen = true
	
	for player in GameData.players:
		if not player.has_chosen_character_card:
			all_characters_chosen = false
	
	GameEvents.player_data_changed.emit()
	GameEvents.ready_to_change_turns.emit()
	

func _on_player_turn_changed() -> void:
	if get_parent().current_state != self:
		return
	if all_characters_chosen: return
	if GameData.current_player.is_computer:
		GameEvents.requested_ai_to_choose_character.emit()
