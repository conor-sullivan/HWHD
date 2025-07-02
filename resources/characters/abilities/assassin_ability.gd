class_name AssassinAbility extends Ability


func do_ability() -> void:
	GameEvents.requested_show_target_picker.emit()
	GameEvents.player_picked_target_character.connect(
	func(_target : CharacterData) -> void:
		print('player selected : ', _target.character_name)
		GameData.current_battle.real_player.will_assassinate_character =_target

		if GameData.current_battle.opponent_player.current_character_card == _target:
			GameData.current_battle.opponent_player.will_be_assassinated = true
		)
	
