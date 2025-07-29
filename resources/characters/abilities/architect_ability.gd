class_name ArchitectAbility extends Ability


func player_do_ability() -> void:
	GameEvents.do_player_arch_ability_vfx.emit()
	GameEvents.requested_player_draw_district_cards.emit(GameData.current_battle.real_player, 2)
	GameEvents.requested_new_in_battle_notification.emit(GameData.current_battle.real_player.player_name, null, ' can play 3 districts this round', '')
	GameData.current_battle.real_player.max_districts_to_play = 3
	GameData.current_battle.real_player.can_use_character_ability = false
	if GameData.current_battle.real_player.districts_played_this_turn < GameData.current_battle.real_player.max_districts_to_play:
		GameData.current_battle.real_player.can_play_district_card = true


func opponent_do_ability() -> void:
	GameEvents.do_opponent_arch_ability_vfx.emit()
	GameEvents.requested_player_draw_district_cards.emit(GameData.current_battle.opponent_player, 2)
	GameData.current_battle.opponent_player.max_districts_to_play = 3
	GameData.current_battle.opponent_player.can_use_character_ability = false
	GameEvents.requested_new_in_battle_notification.emit(GameData.current_battle.real_player.player_name, null, ' can play 3 districts this round', '')
	GameEvents.done_with_opponent_ability.emit()


