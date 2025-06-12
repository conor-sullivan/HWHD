extends Node3D
class_name TestTable

@onready var district : BattleCard3D# = $Monster
@onready var play_zone: CardCollection3D = $"../DragController/PlayZone"

var card_database = DistrictCards3D.new()

func _ready():
	add_card("pikachu")
	add_card("devil")
	add_card("spider")
	add_card("dragon")


func add_card(card_id):
	var scene = load("res://example_battle/scenes/battle_card_3d.tscn")
	var district_card_3d: BattleCard3D = scene.instantiate()
	var card_data: Dictionary = card_database.database[card_id]

	district_card_3d.id = card_data["id"]
	district_card_3d.front_material_path = card_data["front_material_path"]
	district_card_3d.damage = card_data["damage"]

	var hand: CardCollection3D = $"../DragController/CardCollection3D"
	hand.append_card(district_card_3d)


func _on_play_zone_card_added(card: BattleCard3D):
	if !district:
		return

	var index = play_zone.card_indicies[card]
	play_zone.remove_card(index)
	add_child(card)
	card.queue_free()
	district.health -= card.damage
	if district.health <= 0:
		$DragController/PlayZone.play_enabled = false
		district.queue_free()
