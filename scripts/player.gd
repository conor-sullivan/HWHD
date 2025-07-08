extends Node
class_name Player

var player_name : String 
var avatar_texture : Texture2D
var player_id : int 
var current_character_card : CharacterData 
var district_deck_cards : Array[DistrictData]
var is_picking_action : bool = false :
	set(value):
		is_picking_action = value
		GameEvents.player_data_changed.emit()
var is_computer : bool = true
var is_king : bool = false 
var is_winner : bool = false
var in_play_districts_can_be_targeted : bool = true :
	set(value):
		in_play_districts_can_be_targeted = value

		if in_play_districts_can_be_targeted:
			for d in district_cards_in_play:
				d.is_protected = false

		else:
			for d in district_cards_in_play:
				d.is_protected = true

		GameEvents.player_data_changed.emit() 
var can_play_district_card : bool = false :
	set(value):
		can_play_district_card = value
		GameEvents.player_data_changed.emit() 
var has_used_character_ability : bool = false :
	set(value):
		has_used_character_ability = value
		GameEvents.player_data_changed.emit()
var can_use_character_ability : bool = false :
	set(value):
		can_use_character_ability = value
		GameEvents.player_data_changed.emit()
var character_avatar_visible : bool = false :
	set(value):
		character_avatar_visible = value
		GameEvents.player_data_changed.emit()
var has_chosen_character_card : bool = false 
var has_taken_turn : bool = false
var has_been_assassinated : bool = false 
var will_assassinate_character : CharacterData :
	set(value):
		will_assassinate_character = value
		GameEvents.player_data_changed.emit()
var will_rob_character : CharacterData :
	set(value):
		will_rob_character = value
		GameEvents.player_data_changed.emit()
var will_be_assassinated : bool = false 
var has_been_robbed : bool = false
var will_be_robbed : bool = false 
var assassinated_by_player_id : int
var stolen_from_player_id : int
var game_over_rank : int 
var gold_count : int = 0 :
	set(_count):
		var previous_count = gold_count
		var difference = _count - previous_count
		var action = 'gained '
		if difference < 0:
			action = 'lost '
			difference *= -1
		if difference != 0:
			GameEvents.requested_new_in_battle_notification.emit(player_name, null, action + str(difference) + ' gold', '')
		gold_count = _count
		GameEvents.player_data_changed.emit() 
var points_count : int = 0 #-
var district_cards_targetable_by_warlord_count : int = 0
var max_districts_to_play : int = 1
var districts_played_this_turn : int = 0 :
	set(number):
		districts_played_this_turn = number
		if districts_played_this_turn >= max_districts_to_play:
			can_play_district_card = false
			GameEvents.player_data_changed.emit() 
var district_cards_in_play_count : int = 0 : 
	set(count):
		district_cards_in_play_count = count
		GameEvents.player_data_changed.emit() 
var district_cards_in_play : Array[DistrictData] :
	set(cards):
		district_cards_in_play = cards
		district_cards_in_play_count = district_cards_in_play.size()
		GameEvents.player_data_changed.emit() 
var district_cards_in_hand_count : int = 0 : 
	set(value):
		print('new ', value)
		var previous_count = district_cards_in_hand_count
		GameEvents.requested_new_in_battle_notification.emit(player_name, null, 'gained ' + str(value - previous_count) + ' cards', '')
var district_cards_in_hand : Array[DistrictData] :
	set(cards):
		district_cards_in_hand = cards
		district_cards_in_hand_count += cards.size()
		GameEvents.player_data_changed.emit()
var unselected_characters : Array[CharacterData]
var known_excluded_characters : Array[CharacterData] : 
	set(characters):
		known_excluded_characters = characters
		GameEvents.player_data_changed.emit()
var possible_character_targets : Array[CharacterData] :
	set(targets):
		possible_character_targets = targets
		GameEvents.player_data_changed.emit()
