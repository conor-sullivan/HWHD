class_name CharacterCards
extends Resource

var data: Dictionary = _generate_all_face_cards()

#@export var characters : Array[CharacterData3D] = [preload("res://3d_test_scenes/assassin3d.tres")]
var characters : Array[Dictionary] = [{
	'character_name' : 'Assassin',
	'front_texture' : "res://assets/assassin.png",
	'back_texture' : "res://assets/character back.png"
	
}]

func get_card_data(name : String):
	var card_id = name
	
	for character in characters:
		if character['character_name'] == name:
			return character
	#if data.has(card_id):
		#return data[card_id]
	
	return null
	
#func get_card_id(name) -> String:
	#return str(rank) + " of " + str(suit)


func _generate_all_face_cards() -> Dictionary:
	var _data = {}
	
	for character in characters:
		var front_material = character['front_texture']
		var back_material = character['back_texture']
		var card_data = {
		"front_material_path": front_material,
		"back_material_path": back_material
		}
		var card_id = character['character_name']
		_data[card_id] = card_data
			
	return _data
