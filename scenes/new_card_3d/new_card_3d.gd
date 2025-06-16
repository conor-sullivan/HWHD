class_name NewCard3D
extends Card3D

@export var data: Dictionary:
	set(data):
		if data.has("id"):
			id = data["id"]
		
		if data.has("front_material"):
			front_material = data["front_material"]
			
		if data.has("back_material"):
			back_material = data["back_material"]
			
		if data.has("coin_cost"):
			coin_cost = data["coin_cost"]


var id : String
var coin_cost : int :
	set(cost):
		if cost > 0:
			$SubViewport/DistrictCoinCostContainer.create_coins(cost)


var front_material : Material :
	set(material):
		if material:
			if material:
				$CardMesh/CardFrontMesh.set_surface_override_material(0, material)


var back_material : Material:
	set(material):
		if material:
			if material:
				$CardMesh/CardBackMesh.set_surface_override_material(0, material)

func _to_string():
	return id
