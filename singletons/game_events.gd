extends Node

signal drew_cards_from_district_deck(number_of_cards : int)
signal gained_gold(amount : int)
signal placed_card_on_bottom_of_district_deck(card : DistrictCard)
signal activated_special_ability()
signal ended_turn()

signal requested_to_play_top_card_of_character_deck_face_down
signal requested_to_play_top_card_of_character_deck_face_up
signal requested_to_shuffle_character_deck
signal requested_move_pickable_cards_to_character_picker
signal request_make_character_picker_visible

signal character_deck_shuffled
signal played_top_card_of_character_deck(card : CharacterCard)

signal character_deck_ready_to_begin_passing_around(cards_in_deck : Array[CharacterCard], cards_not_in_deck : Array[CharacterCard])

signal character_card_chosen_by_player(card : CharacterData, player_id : int)

signal player_data_changed()

signal card_hovered(hovered_over_card : DistrictCard, card_doing_the_hovering : DistrictCard)
signal card_hovered_off(hovered_over_card : DistrictCard, card_doing_the_hovering : DistrictCard)

signal left_mouse_button_pressed
signal left_mouse_button_released
