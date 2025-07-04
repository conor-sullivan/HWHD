class_name WarlordAbilityDisplayer extends CanvasLayer


func _ready() -> void:
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


func no_targets_available() -> bool:
	for p in GameData.current_battle.players:
		if p.district_cards_targetable_by_warlord_count > 0:
			return false

	return true


func _on_warlord_ability_activated() -> void:
	show()
	show_vignette()

	if no_targets_available():
		GameEvents.requested_new_in_battle_notification.emit('Warlord ', null, 'had 0 targets available', '')

		hide_vignette()
		await get_tree().create_timer(0.2).timeout
		hide()

func _on_district_card_selected_by_warlord(_warlord_player : Player, _card : DistrictData) -> void:
	GameEvents.player_spent_gold.emit(_warlord_player, _card.cost)
	_warlord_player.gold_count -= _card.cost
	GameEvents.requested_new_in_battle_notification.emit(_warlord_player.player_name, null, ' destroyed ', _card.district_name)
	hide_vignette()
	await get_tree().create_timer(0.2).timeout
	hide()
