class_name EndOfRoundState extends State


@export var exclude_characters_state : State

var player_data_is_reset : bool = false


func enter() -> void:
	print('end round state')

	player_data_is_reset = false

	reset_data()


func process_frame(_delta : float) -> State:
	if player_data_is_reset:
		return exclude_characters_state
	else:
		return null


func reset_data() -> void:
	for player in GameData.current_battle.players:
		player.current_character_card = null
		player.district_cards_targetable_by_warlord_count = true
		player.has_taken_turn = false
		player.has_been_assassinated = false
		player.has_been_robbed = false
		player.will_assassinate_character = null
		player.will_be_assassinated = false
		player.will_rob_character = null
		player.will_be_robbed = false
		player.character_avatar_visible = false
		player.possible_character_targets = []
		player.unselected_characters = []
		player.known_excluded_characters = []
		player.districts_played_this_turn = 0
		player.max_districts_to_play = 1

	GameEvents.player_data_changed.emit()

	player_data_is_reset = true