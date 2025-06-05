extends Node
class_name Player

var player_name : String #- name
var avatar_texture : Texture2D #- avatar texture
var player_id : int #- player number (for turn order)
var current_character_card : CharacterData #- chosen character card

var district_deck_cards : Array

var is_computer : bool = true
var is_king : bool = false #- is king
var is_winner : bool = false #- is winner
var has_chosen_character_card : bool = false #- has chosen a character card
var has_taken_turn : bool = false #- has taken turn
var has_been_assassinated : bool = false #- has been assasinated
var will_be_assassinated : bool = false #- will be assasinated
var has_been_stolen_from : bool = false #- has been stolen from
var will_be_stolen_from : bool = false #- will be stolen from

var assassinated_by_player_id : int
var stolen_from_player_id : int

var game_over_rank : int #- game over rank

var gold_count : int = 0 #- gold count
var points_count : int = 0 #- points (based on currently built districts and bonuses)

var districts_built_count : int = 0 #- districts built count
var district_cards_in_play : Array #- districts built and what location they're in on the board
var district_cards_in_hand_count : int = 0 #- cards in hand count
var district_cards_in_hand : Array #- cards in hand and what order they're in
