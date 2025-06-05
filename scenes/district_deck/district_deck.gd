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
	#build_deck()
	
	cards_in_deck.shuffle()
	
	print("deck size ", cards_in_deck.size())
	for card in cards_in_deck:
		card.rotation = randf_range(-random_rotation_amount, random_rotation_amount)


func set_district_deck(deck) -> void:
	for district_resource in deck:
		var card = district_card_scene.instantiate() as DistrictCard
		card.district_resource = district_resource
		cards_in_deck.append(card)


func draw_card() -> DistrictCard:
	var card = cards_in_deck[-1]
	print("drawing " , card.district_resource.district_name)
	#card_in_hand_test = card.duplicate()
	cards_in_deck.erase(card)
	#card.queue_free()
	
	# new
	var new_card = CARD_SCENE.instantiate() as DistrictCard
	var player_hand = get_tree().get_first_node_in_group("player_hand")

	new_card.district_resource = card.district_resource
	#new_card.position = position
	player_hand.add_child(new_card)
	player_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
	#new_card.play_flip_animation()
	new_card.is_face_down = false
	
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
		#print("failed ", err)


func _on_button_pressed() -> void:
	draw_card()


func _on_button_2_pressed() -> void:
	place_card_on_bottom_of_deck(card_in_hand_test)
