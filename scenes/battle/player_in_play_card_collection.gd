class_name PlayerInPlayCardCollection
extends CardCollection3D


@export var shockwave_scene : PackedScene = preload("res://PolyBlocks/EffectBlocks/assets/other/shockwave.tscn")
@export var dust_scene : PackedScene = preload("res://PolyBlocks/EffectBlocks/assets/other/dust_ring.tscn")


func insert_card(card: Card3D, index: int) -> void:
	card.card_3d_mouse_down.connect(_on_card_pressed.bind(card))
	card.card_3d_mouse_up.connect(_on_card_clicked.bind(card))
	card.card_3d_mouse_over.connect(_on_card_hover.bind(card))
	card.card_3d_mouse_exit.connect(_on_card_exit.bind(card))
		
	cards.insert(index, card)


	add_child(card)
	
	GameEvents.requested_camera_shake.emit(0.1, 0.1)

	var spawn_point = get_card_future_position(index)
	create_shockwave(spawn_point)

	for i in range(index, cards.size()):
		card_indicies[cards[i]] = i
	
	apply_card_layout()
	card_added.emit(card)
	GameEvents.player_data_changed.emit()


	GameEvents.player_played_district_card.emit(card.resource)
	card.is_in_play = true


func get_card_future_position(index : int) -> Vector3:
	var card_height = 3.5
	var line = LineCardLayout.new() as LineCardLayout
	var pos = line.calculate_card_position_by_index(cards.size(), index)
	pos.y -= (card_height / 2)
	return pos


func create_shockwave(spawn_point : Vector3) -> void:
	var instance = shockwave_scene.instantiate() as Node3D
	var height_above_table = -1.5
	
	add_child(instance)
	spawn_point.z = height_above_table
	instance.global_position = spawn_point
	instance.rotate_x(deg_to_rad(90))

	var card_height = 3.5
	var dust_instance = dust_scene.instantiate() as Node3D
	add_child(dust_instance)
	var pos = dust_instance.global_position
	pos.y -= (card_height / 4)
	pos.z = height_above_table
	dust_instance.global_position = pos


func can_insert_card(_card: NewCard3D, _from_collection) -> bool:
	return true


func can_select_card(_card: NewCard3D) -> bool:
	return false


func can_reorder_card(_card: NewCard3D) -> bool:
	return false


func can_remove_card(_card: NewCard3D) -> bool:
	return false
