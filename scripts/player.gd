extends Node
class_name Player

var player_name : String 
var avatar_texture : Texture2D
var player_id : int 
var current_character_card : CharacterData 
var district_deck_cards : Array
var is_computer : bool = true
var is_king : bool = false 
var is_winner : bool = false
var can_play_district_card : bool = false :
	set(value):
		can_play_district_card = value
		GameEvents.player_data_changed.emit() 
var has_used_character_ability : bool = false
var can_use_character_ability : bool = false
var character_avatar_visible : bool = false
var has_chosen_character_card : bool = false 
var has_taken_turn : bool = false
var has_been_assassinated : bool = false 
var will_be_assassinated : bool = false 
var has_been_stolen_from : bool = false
var will_be_stolen_from : bool = false 
var assassinated_by_player_id : int
var stolen_from_player_id : int
var game_over_rank : int 
var gold_count : int = 0 :
	set(_count):
		gold_count = _count
		GameEvents.player_data_changed.emit() 
var points_count : int = 0 #-
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
var district_cards_in_play : Array :
	set(cards):
		district_cards_in_play = cards
		district_cards_in_play_count = district_cards_in_play.size()
		GameEvents.player_data_changed.emit() 
var district_cards_in_hand_count : int = 0
var district_cards_in_hand : Array :
	set(cards):
		district_cards_in_hand = cards
		GameEvents.player_data_changed.emit() 
		print('new hand')
