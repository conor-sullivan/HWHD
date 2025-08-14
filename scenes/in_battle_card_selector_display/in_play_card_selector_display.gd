class_name InPlayCardSelectorDisplay extends CanvasLayer

enum AbilityType {
	NECROPOLIS,
	WARLORD
}

var current_ability : AbilityType


func _ready() -> void:
	GameEvents.necropolis_ability_done.connect(_on_necropolis_ability_done)
	GameEvents.trigger_necropolis_ability.connect(_on_trigger_necropolis_ability)
	GameEvents.warlord_ability_done.connect(_on_warlord_ability_done)
	GameEvents.warlord_ability_activated.connect(_on_warlord_ability_activated)
	GameEvents.district_card_selected_by_warlord.connect(_on_district_card_selected_by_warlord)


func show_vignette() -> void:
	var vignette = %Vignette as TextureRect
	vignette.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(vignette, "modulate", Color(1, 1, 1, 1), 0.2) # 0.5 seconds fade-in


func hide_vignette() -> void:
	var vignette = %Vignette as TextureRect
	var tween = create_tween()
	tween.tween_property(vignette, "modulate", Color(1, 1, 1, 0), 0.2) # 0.5 seconds fade


func no_warlord_targets_available() -> bool:
	for p in GameData.current_battle.players:
		if p.district_cards_targetable_by_warlord_count > 0:
			return false
	return true


func no_necropolis_targets_available() -> bool:
	if GameData.current_battle.current_players_turn.district_cards_in_play_count > 0:
		return false
	return true


func _on_warlord_ability_done() -> void:
	hide()


func _on_warlord_ability_activated() -> void:
	show()
	$Button.show()
	show_vignette()

	current_ability = AbilityType.WARLORD
	await get_tree().create_timer(0.25).timeout

	if no_warlord_targets_available():
		GameEvents.warlord_ability_done.emit()
		GameEvents.requested_new_in_battle_notification.emit('Warlord ', null, 'had 0 targets available', '')
		hide_vignette()
		await get_tree().create_timer(0.2).timeout
		hide()


func _on_district_card_selected_by_warlord(_warlord_player : Player, _card : DistrictData) -> void:
	var ability_cost = _card.cost - 1
	GameEvents.player_spent_gold.emit(_warlord_player, ability_cost)
	GameEvents.warlord_ability_done.emit()
	_warlord_player.gold_count -= ability_cost
	GameEvents.requested_new_in_battle_notification.emit(_warlord_player.player_name, null, ' destroyed ', _card.district_name)
	hide_vignette()
	await get_tree().create_timer(0.2).timeout
	hide()


func _on_button_pressed() -> void:
	if current_ability == AbilityType.WARLORD:
		GameEvents.requested_new_in_battle_notification.emit('Warlord ', null, 'selected no targets', '')
		GameEvents.warlord_ability_done.emit()
		GameData.current_battle.current_players_turn.is_doing_warlord_ability = false
	if current_ability == AbilityType.NECROPOLIS:
		GameEvents.necropolis_chose_no_targets.emit(GameData.current_battle.current_players_turn)
		GameEvents.requested_new_in_battle_notification.emit('Necropolis ', null, 'selected no targets', '')
		
	hide_vignette()
	await get_tree().create_timer(0.2).timeout
	hide()


func _on_trigger_necropolis_ability(_player : Player) -> void:
	print('showing...')
	show()
	current_ability = AbilityType.NECROPOLIS
	GameEvents.player_data_changed.emit()
	
	if no_necropolis_targets_available():
		#GameEvents.warlord_ability_done.emit()
		GameEvents.requested_new_in_battle_notification.emit('Necropolis ', null, 'had 0 targets available', '')
		hide_vignette()
		await get_tree().create_timer(0.2).timeout
		hide()
	
	if GameData.current_battle.current_players_turn.district_cards_in_play_count == 2:
		$Button.hide()
	else:
		$Button.show()


func _on_necropolis_ability_done() -> void:
	hide()
