class_name InBattleCharacterTargetPicker extends Control


var choices : Array[CharacterData] :
	set(values):
		choices = values

	# assassin can never be a target, so remove it if needed
		for c in choices:
			if c.play_order_number == 1:
				choices.erase(c)

		%LeftCharacterCard.data = choices[0]
		%LeftCharacterCard.show_front()
		%LeftCharacterCard.reset_tween()
		%LeftCharacterCard.show_shader()

		if choices.size() >= 2:
			%Center.show()
			%CenterCharacterCard.data = choices[1]
			%CenterCharacterCard.show_front()
			%CenterCharacterCard.reset_tween()
			%CenterCharacterCard.show_shader()

		if choices.size() == 3:
			%Right.show()
			%RightCharacterCard.data = choices[2]	
			%RightCharacterCard.show_front()
			%RightCharacterCard.reset_tween()
			%RightCharacterCard.show_shader()


func _on_button_pressed() -> void:
	%Right.hide()
	%Center.hide()
	choices = GameData.current_battle.real_player.possible_character_targets.duplicate()
