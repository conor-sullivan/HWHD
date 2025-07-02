class_name InBattleCharacterTargetPicker extends Control


func _ready() -> void:
	GameEvents.requested_show_target_picker.connect(_on_requested_show_target_picker)


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
		%LeftCharacterCard.enable_collision()

		if choices.size() >= 2:
			%Center.show()
			%CenterCharacterCard.data = choices[1]
			%CenterCharacterCard.show_front()
			%CenterCharacterCard.reset_tween()
			%CenterCharacterCard.show_shader()
			%CenterCharacterCard.enable_collision()

		if choices.size() == 3:
			%Right.show()
			%RightCharacterCard.data = choices[2]	
			%RightCharacterCard.show_front()
			%RightCharacterCard.reset_tween()
			%RightCharacterCard.show_shader()
			%RightCharacterCard.enable_collision()


func _on_requested_show_target_picker():
	%Right.hide()
	%Center.hide()
	choices = GameData.current_battle.real_player.possible_character_targets.duplicate()
	show()
