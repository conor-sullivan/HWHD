class_name CardsDatabase
extends Resource

@export var district_resources : Array[DistrictData] = [
	preload("res://resources/districts/armory.tres"),
	preload("res://resources/districts/barracks.tres"),
	preload("res://resources/districts/bell_tower.tres"),
	preload("res://resources/districts/castle.tres"),
	preload("res://resources/districts/cathedrel.tres"),
	preload("res://resources/districts/church.tres"),
	preload("res://resources/districts/docks.tres"),
	preload("res://resources/districts/fortress.tres"),
	preload("res://resources/districts/hospital.tres"),
	preload("res://resources/districts/imperial_treasure.tres"),
	preload("res://resources/districts/keep.tres"),
	preload("res://resources/districts/lighthouse.tres"),
	preload("res://resources/districts/manor.tres"),
	preload("res://resources/districts/map_room.tres"),
	preload("res://resources/districts/market.tres"),
	preload("res://resources/districts/montastery.tres"),
	preload("res://resources/districts/necropolis.tres"),
	preload("res://resources/districts/palace.tres"),
	preload("res://resources/districts/park.tres"),
	preload("res://resources/districts/poor_house.tres"),
	preload("res://resources/districts/prison.tres"),
	preload("res://resources/districts/school_of_magic.tres"),
	preload("res://resources/districts/tavern.tres"),
	preload("res://resources/districts/temple.tres")
]

@export var character_resources : Array[CharacterData] = [
	preload("res://resources/characters/architect.tres"),
	preload("res://resources/characters/assassin.tres"),
	preload("res://resources/characters/bishop.tres"),
	preload("res://resources/characters/king.tres"),
	preload("res://resources/characters/magician.tres"),
	preload("res://resources/characters/merchant.tres"),
	preload("res://resources/characters/thief.tres"),
	preload("res://resources/characters/warlord.tres")
]


func get_district_database() -> Dictionary:
	var result : Dictionary
	for resource in district_resources:
		result[resource.district_name] = []
		print(resource.get_property_list())
		for element in resource:
			result[resource.district_name][element.name] = element
	
	return result


func get_district_card(id : String) -> DistrictData:
	var card : DistrictData
	for resource in district_resources:
		if resource.district_name == id:
			card = resource
	print(card.sprite_texture)
	return card


var old_district_database : Dictionary = {
	"armoury": {
		"id": "armoury",
		"coin_cost": 4,
		"color" : "red",
		"front_material_path": "res://resources/district_cards/armoury.tres",
		"back_material_path": "res://resources/district_cards/district_back.tres"
	},
	"barracks": {
		"id": "barracks",
		"coin_cost": 3,
		"color": "red",
		"front_material_path": "res://resources/district_cards/barracks.tres",
		"back_material_path": "res://resources/district_cards/district_back.tres"
	},
	"bell_tower": {
		"id": "bell_tower",
		"coin_cost": 4,
		"color": "purple",
		"front_material_path": "res://resources/district_cards/bell_tower.tres",
		"back_material_path": "res://resources/district_cards/district_back.tres"
	},
	"castle": {
		"id": "castle",
		"coin_cost": 4,
		"color": "gold",
		"front_material_path": "res://resources/district_cards/castle.tres",
		"back_material_path": "res://resources/district_cards/district_back.tres"
	},
	"cathedral": {
		"id": "cathedral",
		"coin_cost": 5,
		"color": "blue",
		"front_material_path": "res://resources/district_cards/cathedral.tres",
		"back_material_path": "res://resources/district_cards/district_back.tres"
	},
	"church": {
		"id": "church",
		"coin_cost": 3,
		"color": "blue",
		"front_material_path": "res://resources/district_cards/church.tres",
		"back_material_path": "res://resources/district_cards/district_back.tres"
	},
	"docks": {
		"id": "docks",
		"coin_cost": 3,
		"color": "green",
		"front_material_path": "res://resources/district_cards/docks.tres",
		"back_material_path": "res://resources/district_cards/district_back.tres"
	},
	"fortress": {
		"id": "fortress",
		"coin_cost": 5,
		"color": "red",
		"front_material_path": "res://resources/district_cards/fortress.tres",
		"back_material_path": "res://resources/district_cards/district_back.tres"
	}
}


var old_character_database: Dictionary = {
	"assassin": {
		"id": "assassin",
		"turn_order": 1,
		"front_material_path": "res://resources/character_cards/assassin.tres",
		"back_material_path": "res://resources/character_cards/character_back.tres"
	},
	"thief": {
		"id": "thief",
		"turn_order": 2,
		"front_material_path": "res://resources/character_cards/thief.tres",
		"back_material_path": "res://resources/character_cards/character_back.tres"
	},
	"magician": {
		"id": "magician",
		"turn_order": 3,
		"front_material_path": "res://resources/character_cards/magician.tres",
		"back_material_path": "res://resources/character_cards/character_back.tres"
	},
		"king": {
		"id": "king",
		"turn_order": 4,
		"front_material_path": "res://resources/character_cards/king.tres",
		"back_material_path": "res://resources/character_cards/character_back.tres"
	},
		"bishop": {
		"id": "bishop",
		"turn_order": 5,
		"front_material_path": "res://resources/character_cards/bishop.tres",
		"back_material_path": "res://resources/character_cards/character_back.tres"
	},
		"merchant": {
		"id": "merchant",
		"turn_order": 6,
		"front_material_path": "res://resources/character_cards/merchant.tres",
		"back_material_path": "res://resources/character_cards/character_back.tres"
	},
		"architect": {
		"id": "architect",
		"turn_order": 7,
		"front_material_path": "res://resources/character_cards/architect.tres",
		"back_material_path": "res://resources/character_cards/character_back.tres"
	},
		"warlord": {
		"id": "warlord",
		"turn_order": 8,
		"front_material_path": "res://resources/character_cards/warlord.tres",
		"back_material_path": "res://resources/character_cards/character_back.tres"
	},
}
