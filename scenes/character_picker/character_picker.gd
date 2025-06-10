extends Control
class_name CharacterPicker


func _ready() -> void:
	GameEvents.player_turn_changed.connect(_on_player_turn_changed)
	GameEvents.request_make_character_picker_visible.connect(make_visible)
	GameEvents.on_moved_pickable_card_to_character_picker.connect(add_to_pickable_cards)
	GameEvents.on_character_card_hovered_on.connect(_on_character_card_hovered_on)
	GameEvents.on_character_card_hovered_off.connect(_on_character_card_hovered_off)
	GameEvents.requested_to_pick_random_character_card.connect(pick_random_card)
	GameEvents.all_characters_picked.connect(_on_all_characters_picked)


func add_to_pickable_cards(card : CharacterCard) -> void:
	$HBoxContainer.add_child(card)
	await card.play_reveal_flip_animation()
	card.play_waiting_to_pick()
	card.enable_collider()
	
	randomize_card_order()

func randomize_card_order() -> void:
	if $HBoxContainer.get_children().size() > 1:
		for card in $HBoxContainer.get_children():
			$HBoxContainer.move_child(card, randi_range(0, $HBoxContainer.get_children().size()))


func remove_from_pickable_cards(card : CharacterCard) -> void:
	$HBoxContainer.remove_child(card)


func make_visible() -> void:
	set_title_label()
	visible = true


func set_title_label() -> void:
	$TitleLabel.text = GameData.current_player.player_name + ", choose your character"
	

func _on_character_card_hovered_on(card : CharacterCard) -> void:
	update_ability_text(card.character_resource.special_ability_text)


func _on_character_card_hovered_off(card : CharacterCard) -> void:
	update_ability_text("")


func update_ability_text(text : String) -> void:
	$AbilityLabelBox.text = text


func _on_player_turn_changed() -> void:
	update_ability_text("")
	if GameData.current_player.is_computer:
		for card in $HBoxContainer.get_children():
			(card as CharacterCard).play_hide_flip_animation()
	else:
		for card in $HBoxContainer.get_children():
			(card as CharacterCard).play_reveal_flip_animation()
	randomize_card_order()
	set_title_label()
	$AnimationPlayer.play("stack_and_unstack_cards")


func pick_random_card() -> void:
	var cards = $HBoxContainer.get_children()
	var card : CharacterCard
	if cards.size() > 1:
		var random_index = randi_range(0, cards.size() - 1)
		card = cards[random_index]
	else: 
		card = cards[0]
	print("random card chosen : ", card.character_resource.character_name)
	card.set_card_as_picked()


func _on_all_characters_picked() -> void:
	visible = false
