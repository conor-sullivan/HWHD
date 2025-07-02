class_name InBattleCharacterTargetPicker extends Control


var choices : Array[CharacterData] :
	set(values):
		choices = values

		if choices.size() == 2:
			%LeftCharacterCard.data = choices[0]
			%LeftCharacterCard.show_front()
			%LeftCharacterCard.reset_tween()
			%LeftCharacterCard.show_shader()

			%RightCharacterCard.data = choices[1]	
			%RightCharacterCard.show_front()
			%RightCharacterCard.reset_tween()
			%RightCharacterCard.show_shader()


func _on_button_pressed() -> void:
	choices = GameData.current_battle.real_player.possible_character_targets	
