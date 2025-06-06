extends Node2D
class_name DistrictDeck

const CARD_SCENE = preload("res://scenes/district_card/district_card.tscn")
const CARD_DRAW_SPEED : float = 0.3

@export var district_card_scene : PackedScene = preload("res://scenes/district_card/district_card.tscn")
@export var gold_card_resources : Array[DistrictData]
@export var blue_card_resources : Array[DistrictData]
@export var red_card_resources : Array[DistrictData]
@export var green_card_resources : Array[DistrictData]
@export var purple_card_resources : Array[DistrictData]
@export var cards_in_deck : Array
@export var random_rotation_amount : float = 0.05

var card_in_hand_test : DistrictCard


func _ready() -> void:
	GameEvents.requested_to_draw_cards_from_district_deck.connect(_on_requested_to_draw_cards_from_district_deck)
	GameEvents.set_district_deck.connect(_on_set_district_deck)


func _on_set_district_deck(deck : Array[DistrictData]) -> void:
	for card_resource in deck:
		var new_card_instance = CARD_SCENE.instantiate()
		new_card_instance.district_resource = card_resource
		$CardsInDeck.add_child(new_card_instance)

	for district_resource in deck:
		var card = district_card_scene.instantiate() as DistrictCard
		card.district_resource = district_resource
		cards_in_deck.append(card)
	
	cards_in_deck.shuffle()
	
	for card in cards_in_deck:
		card.rotation = randf_range(-random_rotation_amount, random_rotation_amount)


func draw_card() -> DistrictCard:
	
	var card = cards_in_deck[0] as DistrictCard
	print("drawing card, ", card.district_resource.district_name)
	cards_in_deck.erase(card)

	# new
	var new_card = CARD_SCENE.instantiate() as DistrictCard

	new_card.district_resource = card.district_resource
	GameEvents.requested_add_district_card_to_hand.emit(new_card)

	new_card.is_face_down = false
	
	GameData.current_player.district_cards_in_hand.append(new_card.district_resource)
	GameData.current_player.district_cards_in_hand_count = GameData.current_player.district_cards_in_hand.size()
	GameEvents.player_data_changed.emit()
	
	return card


func draw_two_cards() -> Array:
	var cards = []
	for i in 2:
		cards.append(draw_card())
		$TimeBetweenCardDrawTimer.start()
		await  $TimeBetweenCardDrawTimer.timeout
	return cards


func draw_four_cards() -> Array:
	var cards = []
	for i in 4:
		cards.append(draw_card())
		$TimeBetweenCardDrawTimer.start()
		await  $TimeBetweenCardDrawTimer.timeout
	return cards


func _on_requested_to_draw_cards_from_district_deck(number_of_cards) -> void:

	var cards = []
	for i in number_of_cards:
		cards.append(draw_card())
		$TimeBetweenCardDrawTimer.start()
		await  $TimeBetweenCardDrawTimer.timeout
	#return cards
	pass


func place_card_on_bottom_of_deck(card : DistrictCard) -> void:
	cards_in_deck.insert(0, card)


func build_deck() -> void:
	# for saving deck to resource file
	#var resource = load("res://resources/district_decks/default_district_deck.tres") as DistrictDeckData
	
	
	# gold cards
	for i in 4:
		for available_card_option in gold_card_resources:
			var card = district_card_scene.instantiate() as DistrictCard
			card.district_resource = available_card_option
			cards_in_deck.append(card)
			$CardsInDeck.add_child(card)
			#resource.cards_in_deck.append(card.district_resource)
	
	# blue cards
	for i in 4:
		for available_card_option in blue_card_resources:
			var card = district_card_scene.instantiate() as DistrictCard
			card.district_resource = available_card_option
			cards_in_deck.append(card)
			$CardsInDeck.add_child(card)
			#resource.cards_in_deck.append(card.district_resource)
	
	# red cards
	for i in 4:
		for available_card_option in red_card_resources:
			var card = district_card_scene.instantiate() as DistrictCard
			card.district_resource = available_card_option
			cards_in_deck.append(card)
			$CardsInDeck.add_child(card)
			#resource.cards_in_deck.append(card.district_resource)
	
	# green cards
	for i in 4:
		for available_card_option in green_card_resources:
			var card = district_card_scene.instantiate() as DistrictCard
			card.district_resource = available_card_option
			cards_in_deck.append(card)
			$CardsInDeck.add_child(card)
			#resource.cards_in_deck.append(card.district_resource)
	
	# purple cards
	for i in 2:
		for available_card_option in purple_card_resources:
			var card = district_card_scene.instantiate() as DistrictCard
			card.district_resource = available_card_option
			cards_in_deck.append(card)
			$CardsInDeck.add_child(card)
			#resource.cards_in_deck.append(card.district_resource)
	#
	#var err = ResourceSaver.save(resource, "res://resources/district_decks/default_district_deck.tres")
	#
	#if err != OK:
		##print("failed ", err)


func _on_button_pressed() -> void:
	draw_card()


func _on_button_2_pressed() -> void:
	place_card_on_bottom_of_deck(card_in_hand_test)
