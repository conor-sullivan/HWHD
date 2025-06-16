class_name TestCard3D
extends Card3D

@export var data: Dictionary:
	set(data):
		if data.has("id"):
			id = data["id"]
		
		if data.has("front_material_path"):
			front_material_path = data["front_material_path"]
			
		if data.has("back_material_path"):
			back_material_path = data["back_material_path"]
			
		if data.has("coin_cost"):
			coin_cost = data["coin_cost"]


var id : String
var coin_cost : int :
	set(cost):
		if cost > 0:
			$SubViewport/DistrictCoinCostContainer.create_coins(cost)


var front_material_path : String :
	set(path):
		if path:
			var material = load(path)
			
			if material:
				$CardMesh/CardFrontMesh.set_surface_override_material(0, material)


var back_material_path : String:
	set(path):
		if path:
			var material = load(path)
			
			if material:
				$CardMesh/CardBackMesh.set_surface_override_material(0, material)

func _to_string():
	return id
