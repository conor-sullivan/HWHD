extends Node

signal accepted_character_cards
signal done_drawing_initial_character_cards
signal requested_draw_character_card(facedown : bool)
signal ready_to_exclude_characters
signal player_data_changed
signal requested_player_draw_district_cards(player : Player, count : int)
