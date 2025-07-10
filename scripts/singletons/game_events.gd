extends Node


@warning_ignore("unused_signal")
signal requested_player_rob_player(robbing_player : Player, robbed_player : Player)

@warning_ignore("unused_signal")
signal opponent_deck_cards_ready_for_gain_card_action(cards_to_select_from : Array[DistrictData])

@warning_ignore("unused_signal")
signal requested_opponent_gain_card_action

@warning_ignore("unused_signal")
signal requested_opponent_play_card_from_hand(card : DistrictData)

@warning_ignore("unused_signal")
signal requested_district_destroyed_by_opponent(card : DistrictData)

@warning_ignore("unused_signal")
signal done_with_opponent_ability

@warning_ignore("unused_signal")
signal requested_show_magician_discard_display

@warning_ignore("unused_signal")
signal requested_discard_magician_ability

@warning_ignore("unused_signal")
signal requested_player_discard_cards(cards_to_discard : Array[DistrictData])

@warning_ignore("unused_signal")
signal done_selecting_magician_discards(cards_to_discard : Array[DistrictData])

@warning_ignore("unused_signal")
signal requested_players_exchange_hands

@warning_ignore("unused_signal")
signal starting_magician_ability(first_option : Callable, second_option : Callable)

@warning_ignore("unused_signal")
signal warlord_ability_done

@warning_ignore("unused_signal")
signal district_card_destroyed_by_warlord(card_owner : Player, card : DistrictData)

@warning_ignore("unused_signal")
signal district_card_selected_by_warlord(warlord_player : Player, card : DistrictData)

@warning_ignore("unused_signal")
signal warlord_ability_activated

@warning_ignore("unused_signal")
signal end_player_turn(player : Player)

@warning_ignore("unused_signal")
signal requested_new_in_battle_notification(attacker_name : String, icon_texture : Texture, action : String, target_name : String)

@warning_ignore("unused_signal")
signal player_picked_target_character(character : CharacterData)

@warning_ignore("unused_signal")
signal requested_show_target_picker

@warning_ignore("unused_signal")
signal requested_append_card_in_player_discard(player, card : NewCard3D)

@warning_ignore("unused_signal")
signal requested_append_card_in_player_hand(player : Player, card : NewCard3D)

@warning_ignore("unused_signal")
signal player_ready_to_choose_action

@warning_ignore("unused_signal")
signal player_picked_district_card_to_keep(player : Player, kept_card : DistrictData, discarded_card : DistrictData)

@warning_ignore("unused_signal")
signal requested_gain_card_action(player : Player)

@warning_ignore("unused_signal")
signal deck_cards_ready_for_gain_card_action(player : Player, cards : Array[DistrictData])

@warning_ignore("unused_signal")
signal requested_show_in_battle_action_selection

@warning_ignore("unused_signal")
signal in_battle_action_selected(action : Callable)

@warning_ignore("unused_signal")
signal player_played_district_card(card : DistrictData)

@warning_ignore("unused_signal")
signal player_spent_gold(player : Player, count : int)

@warning_ignore("unused_signal")
signal player_gained_gold(player : Player, count : int)

@warning_ignore("unused_signal")
signal started_player_turn_state

@warning_ignore("unused_signal")
signal character_choices_provided(characters : Array[CharacterData])

@warning_ignore("unused_signal")
signal players_character_card_selected(character : CharacterData)

@warning_ignore("unused_signal")
signal opponents_character_card_selected(character : CharacterData)

@warning_ignore("unused_signal")
signal all_character_cards_chosen()

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
