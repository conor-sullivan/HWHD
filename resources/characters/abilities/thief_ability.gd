class_name ThiefAbility extends Ability


func player_do_ability() -> void:
	GameEvents.requested_show_target_picker.emit()
	GameEvents.player_picked_target_character.connect(

	func(_target : CharacterData) -> void:
		GameEvents.requested_new_in_battle_notification.emit(GameData.current_battle.real_player.player_name, null, ' chooses to rob ' , _target.character_name)
		GameData.current_battle.real_player.will_rob_character =_target
		GameData.current_battle.real_player.can_use_character_ability = false

		if GameData.current_battle.opponent_player.current_character_card == _target:
			GameData.current_battle.opponent_player.will_be_robbed = true
		)
	

func opponent_do_ability() -> void:
	# for now just pick randomly - implement ai smart choices later
	var targets = GameData.current_battle.opponent_player.possible_character_targets
	for t in targets:
		if t.play_order_number == 1:
			targets.erase(t)
	var random_index = randi_range(0, targets.size() - 1)

	var target = targets[random_index]

	GameData.current_battle.opponent_player.will_rob_character = target

	if GameData.current_battle.real_player.current_character_card == target:
		GameData.current_battle.real_player.will_be_robbed = true
