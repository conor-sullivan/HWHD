class_name InitializeBattleState
extends State

@export var exclude_characters_state : State
@export var character_resources : Array[CharacterData]

var players_ready : bool = false


func enter() -> void:
	var real_player = create_player(0, 'Real Player', "", 2, GameData.player_current_district_deck_build, false)
	real_player.is_king = true
	var opponent_player = create_player(1, "AI", "", 2, GameData.player_current_district_deck_build, true)
	
	GameData.current_battle = BattleData.new()
	GameData.current_battle.real_player = real_player
	GameData.current_battle.players = [real_player, opponent_player]
	GameData.current_battle.character_cards = character_resources

	await get_tree().create_timer(0.25).timeout
	draw_initial_cards()


func exit() -> void:
	GameEvents.player_data_changed.emit()


func process_frame(_delta : float) -> State:
	if players_ready:
		return exclude_characters_state
	else:
		return null


func create_player(id : int, _name : String, texture_location : String, gold : int, card_resources : Array[DistrictData], is_computer : bool) -> Player:
	var new_player = Player.new()
	new_player.player_id = id
	new_player.player_name = _name
	if texture_location:
		new_player.avatar_texture = load(texture_location)
	new_player.gold_count = gold
	new_player.district_deck_cards = card_resources
	new_player.is_computer = is_computer
	
	return new_player


func draw_initial_cards() -> void:
	for player in GameData.current_battle.players:
		GameEvents.requested_player_draw_district_cards.emit(player, 4)
		await get_tree().create_timer(0.25).timeout
	
	await get_tree().create_timer(0.25).timeout

	players_ready = true
