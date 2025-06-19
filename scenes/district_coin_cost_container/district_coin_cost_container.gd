class_name DistrictCoinCostContainer
extends Node2D

@export var coin_scene : PackedScene 


func create_coins(coin_count : int) -> void:
	for c in coin_count:
		var instance = coin_scene.instantiate()
		$VBoxContainer.add_child(instance)


func remove_all_coins() -> void:
	for child in $VBoxContainer.get_children():
		child.call_deferred("queue_free")
