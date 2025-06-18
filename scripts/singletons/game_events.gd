extends Node

@warning_ignore("unused_signal")
signal character_choices_provided(characters : Array[CharacterData])

@warning_ignore("unused_signal")
signal players_character_card_selected(character : CharacterData)

@warning_ignore("unused_signal")
signal opponents_character_card_selected(character : CharacterData)

@warning_ignore("unused_signal")
signal all_character_cards_chosen(data : Dictionary)

@warning_ignore("unused_signal")
signal accepted_character_cards

@warning_ignore("unused_signal")
signal done_drawing_initial_character_cards

@warning_ignore("unused_signal")
signal done_drawing_available_character_cards

@warning_ignore("unused_signal")
signal starting_excluded_characters_state

@warning_ignore("unused_signal")
signal starting_select_character_state(number_of_cards : int)

@warning_ignore("unused_signal")
signal requested_show_in_battle_character_card_handler_overlay

@warning_ignore("unused_signal")
signal requested_draw_character_card(face_down : bool)

@warning_ignore("unused_signal")
signal ready_to_exclude_characters

@warning_ignore("unused_signal")
signal player_data_changed

@warning_ignore("unused_signal")
signal requested_player_draw_district_cards(player : Player, count : int)
