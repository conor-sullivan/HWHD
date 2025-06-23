class_name NewCard3D
extends Card3D


@export var aura_shader : ShaderMaterial = preload("res://shaders/3d_card_aura_material.tres")
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
			cost = coin_cost
		
		if data.has("sprite_texture"):
			sprite_texture = data["sprite_texture"]

var resource : Resource
#var is_in_hand: bool = false
var is_real_players : bool = false
var sprite_texture = Texture
var mouse_inside : bool = false
var id : String
var cost : int
var coin_cost : int :
	set(cost):
		if cost > 0:
			$CardMesh/CostBackSprite3D/CostLabel.text = str(cost)


var front_material : Material :
	set(material):
		if material:
			$CardMesh/CardFrontMesh.set_surface_override_material(0, material)


var back_material : Material:
	set(material):
		if material:
			$CardMesh/CardBackMesh.set_surface_override_material(0, material)


func _ready() -> void:
	GameEvents.player_data_changed.connect(_on_player_data_changed)
	GameEvents.started_player_turn_state.connect(_on_started_player_turn_state)
	GameEvents.starting_excluded_characters_state.connect(_on_starting_excluded_characters_state)



func player_can_afford() -> bool:
	if resource is DistrictData:
		cost = resource.cost
	if not GameData.current_battle:
		return false
	if GameData.current_battle.real_player.gold_count >= cost:
		return true
	else:
		return false


func _on_player_data_changed() -> void:
	set_shader()


func is_in_hand() -> bool:
	if get_parent().is_in_group('player_hand_collection'):
		return true
	else:
		return false


func set_shader() -> void:
	$CardMesh/CardFrontMesh.material_overlay = null
	if not GameData.current_battle: return
	if not GameData.current_battle.real_player.can_play_district_card:
		return
	if player_can_afford() and is_in_hand():
		$CardMesh/CardFrontMesh.material_overlay = aura_shader



func _on_started_player_turn_state() -> void:
	enable_collision()


func _on_starting_excluded_characters_state() -> void:
	disable_collision()


func _to_string():
	return id


func _on_static_body_3d_mouse_entered():
	super()
	
	if face_down: 
		return
		
	$PopupTimer.start()
	mouse_inside = true

func _on_static_body_3d_mouse_exited():
	super()
	
	if face_down: 
		return
		
	$PopupTimer.stop()
	mouse_inside = false
	DistrictCardPopups.hide_item_popup()


func _on_popup_timer_timeout() -> void:
	if face_down: 
		return
		
	if mouse_inside:
		DistrictCardPopups.item_popup(null, sprite_texture, (resource as DistrictData).cost)
