class_name NewCard3D extends Card3D

enum Type {CHARACTER, DISTRICT}

@export var card_type : Type
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

var resource : Resource :
	set(value):
		resource = value
		if resource is CharacterData:
			card_type = Type.CHARACTER
		elif resource is DistrictData:
			card_type = Type.DISTRICT
#var is_in_hand: bool = false
var is_real_players : bool = false
var is_targetable_by_warlord : bool = false
var is_in_play : bool = false
var player_owner : Player 
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
	GameEvents.warlord_ability_done.connect(_on_warlord_ability_done)
	GameEvents.player_data_changed.connect(_on_player_data_changed)
	GameEvents.started_player_turn_state.connect(_on_started_player_turn_state)
	GameEvents.starting_excluded_characters_state.connect(_on_starting_excluded_characters_state)
	GameEvents.warlord_ability_activated.connect(_on_warlord_ability_activated)


func player_can_afford() -> bool:
	if resource is DistrictData:
		cost = resource.cost
	if not GameData.current_battle:
		return false
	if GameData.current_battle.real_player.gold_count >= cost:
		return true
	else:
		return false
		

func player_is_taking_action() -> bool:
	return GameData.current_battle.real_player.is_picking_action


func _on_player_data_changed() -> void:
	set_shader()


func is_in_hand() -> bool:
	if get_parent() == null:
		return false
	if get_parent().is_in_group('player_hand_collection'):
		return true
	else:
		return false


func set_shader() -> void:
	if is_targetable_by_warlord:
		return
	%Shader.hide()
	if not GameData.current_battle: return
	if not GameData.current_battle.real_player.can_play_district_card: return
	if player_is_taking_action(): return
	if player_can_afford() and is_in_hand():
		%Shader.show()


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


func _on_warlord_ability_activated() -> void:
	if not player_owner:
		return
	if not is_in_play:
		return
	if card_type != Type.DISTRICT:
		return
	if not player_owner.in_play_districts_can_be_targeted:
		return

	if GameData.current_battle.current_players_turn.gold_count >= (cost - 1):
		is_targetable_by_warlord = true
	else:
		is_targetable_by_warlord = false

	if is_targetable_by_warlord:
		%Shader.show()


func _on_static_body_3d_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		var button = event.button_index
		var pressed = event.pressed
		if button == 1 and pressed == true:
			card_3d_mouse_down.emit()
			if is_targetable_by_warlord:
				disable_collision()
				GameEvents.district_card_selected_by_warlord.emit(GameData.current_battle.current_players_turn, resource)
				%ExplosionParticles.show()
				%ExplosionParticles.emitting = true
				await %ExplosionParticles.finished
				GameEvents.district_card_destroyed_by_warlord.emit(player_owner, resource)
				call_deferred("queue_free")
		elif button == 1 and pressed == false:
			card_3d_mouse_up.emit()
		

func _on_warlord_ability_done() -> void:
	is_targetable_by_warlord = false
	%Shader.hide()