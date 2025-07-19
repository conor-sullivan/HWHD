class_name PlayerInPlayCardCollection
extends CardCollection3D


@export var shockwave_scene : PackedScene = preload("res://PolyBlocks/EffectBlocks/assets/other/shockwave_showcase.tscn")


func insert_card(card: Card3D, index: int) -> void:
	super(card, index)

	var spawn_point = get_card_future_position(index)
	create_shockwave(spawn_point)

	GameEvents.player_played_district_card.emit(card.resource)
	card.is_in_play = true
	
#	await get_tree().create_timer(0.5).timeout


func get_card_future_position(index : int) -> Vector3:
	var card_height = 3.5
	var line = LineCardLayout.new() as LineCardLayout
	var pos = line.calculate_card_position_by_index(cards.size(), index)
	pos.y -= (card_height / 2)
	return pos


func create_shockwave(spawn_point : Vector3) -> void:
	var instance = shockwave_scene.instantiate() as Node3D

	add_child(instance)
	spawn_point.z = -1.7
	instance.global_position = spawn_point
	instance.rotate_x(deg_to_rad(90))

	await get_tree().create_timer(0.5).timeout
#	instance.queue_free()


func can_insert_card(_card: NewCard3D, _from_collection) -> bool:
	return true


func can_select_card(_card: NewCard3D) -> bool:
	return false


func can_reorder_card(_card: NewCard3D) -> bool:
	return false


func can_remove_card(_card: NewCard3D) -> bool:
	return false
