class_name NewCard3D extends Card3D

enum Type {CHARACTER, DISTRICT}


@export var coin_scene : PackedScene = preload("res://scenes/district_card_coin_fx/district_card_coin_gain_fx.tscn")
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
	GameEvents.do_poor_house_ability.connect(_on_poor_house_ability)
	GameEvents.player_turn_ended.connect(_on_player_turn_ended)
	GameEvents.requested_district_destroyed_by_opponent.connect(_on_requested_district_destroyed_by_opponent)
	GameEvents.warlord_ability_done.connect(_on_warlord_ability_done)
	GameEvents.player_data_changed.connect(_on_player_data_changed)
	GameEvents.started_player_turn_state.connect(_on_started_player_turn_state)
	GameEvents.starting_excluded_characters_state.connect(_on_starting_excluded_characters_state)
	GameEvents.warlord_ability_activated.connect(_on_warlord_ability_activated)
	GameEvents.gain_gold_for_districts.connect(_on_gain_gold_for_districts)


func _on_player_turn_ended() -> void:
	%Shader.hide()


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
	is_targetable_by_warlord = false

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

	if is_targetable_by_warlord:
		%Shader.show()


func _on_static_body_3d_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		var button = event.button_index
		var pressed = event.pressed
		if button == 1 and pressed == true:
			card_3d_mouse_down.emit()

			if is_targetable_by_warlord:
				if not player_owner.in_play_districts_can_be_targeted:
					return

				player_owner.in_play_districts_can_be_targeted = false

				disable_collision()
				GameEvents.district_card_selected_by_warlord.emit(GameData.current_battle.current_players_turn, resource)

				%ExplosionParticles.start()
				await get_tree().create_timer(0.5).timeout

				GameEvents.district_card_destroyed_by_warlord.emit(player_owner, resource)

				var parent_collection = get_parent()
				if parent_collection is CardCollection3D:
					var index = parent_collection.cards.find(self)
					if index != -1:
						parent_collection.remove_card(index)
						call_deferred("queue_free")
		elif button == 1 and pressed == false:
			card_3d_mouse_up.emit()
		

func _on_warlord_ability_done() -> void:
	is_targetable_by_warlord = false
	%Shader.hide()


func _on_requested_district_destroyed_by_opponent(_card : DistrictData) -> void:
	if not is_targetable_by_warlord:
		return
	if _card != resource:
		return
	disable_collision()
#	GameEvents.district_card_selected_by_warlord.emit(GameData.current_battle.current_players_turn, resource)
	%ExplosionParticles.start()
	await get_tree().create_timer(0.5).timeout

	GameEvents.district_card_destroyed_by_warlord.emit(player_owner, resource)

	var parent_collection = get_parent()
	if parent_collection is CardCollection3D:
		var index = parent_collection.cards.find(self)
		if index != -1:
			parent_collection.remove_card(index)
			call_deferred("queue_free")


func _on_gain_gold_for_districts(player : Player, _color : String) -> void:
	# Only act if this card is in play, belongs to the player, and is a gold district
	if not is_in_play:
		return
	if player != player_owner:
		return
	if not resource is DistrictData:
		return
	if resource.district_name == 'School of Magic':
		spawn_and_animate_coin()
		GameEvents.player_gained_gold.emit(player, 1)
		return
	if resource.color == _color:
		spawn_and_animate_coin()
	

func spawn_and_animate_coin():
	var coin = coin_scene.instantiate() as Node3D
	
	var battle = get_tree().get_first_node_in_group("battle")
	if not battle:
		return
	battle.add_child(coin)	
	
	var pos = global_position
	var card_height = 3
	pos.z = 1
	pos.y += card_height
	coin.global_position = pos


func _on_poor_house_ability() -> void:
	if not is_in_play:
		return
	if not resource is DistrictData:
		return
	if resource.district_name != 'Poor House':
		return
	
	var player = GameData.current_battle.current_players_turn

	if player != player_owner:
		return

	spawn_and_animate_coin()
