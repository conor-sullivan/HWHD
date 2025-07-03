class_name AssassinAbility extends Ability


func player_do_ability() -> void:
	GameEvents.requested_show_target_picker.emit()
	GameEvents.player_picked_target_character.connect(

	func(_target : CharacterData) -> void:
		GameEvents.requested_new_in_battle_notification.emit(GameData.current_battle.real_player.player_name, null, ' chooses to assassinate ' , _target.character_name)
		GameData.current_battle.real_player.will_assassinate_character =_target

		if GameData.current_battle.opponent_player.current_character_card == _target:
			GameData.current_battle.opponent_player.will_be_assassinated = true
		)
	

func opponent_do_ability() -> void:
	# for now just pick randomly - implement ai smart choices later
	var targets = GameData.current_battle.opponent_player.possible_character_targets
	for t in targets:
		if t.play_order_number == 1:
			targets.erase(t)
	var random_index = randi_range(0, targets.size() - 1)

	var target = targets[random_index]

	GameData.current_battle.opponent_player.will_assassinate_character = target

	if GameData.current_battle.real_player.current_character_card == target:
		GameData.current_battle.real_player.will_be_assassinated = true
