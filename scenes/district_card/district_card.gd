extends Node2D
class_name DistrictCard

enum CardBackgroundRegionX {
	Blue = 0,
	Red = 119,
	Gray = 236,
	Green = 352,
	Gold = 467
}

@export var is_purple_foil : bool = false
@export var district_resource : DistrictData
@export var max_tilt_angle = 45.0
@export var tilt_strength := 0.9 # adjust to control tilt amount
@export var tilt_smoothing := 10 # how fast the rotation follows the movement

var position_in_hand : Vector2
var is_in_card_slot : bool = false
var is_being_dragged : bool = false
var is_face_down : bool = true
var is_highlighted : bool = false
var previous_position := Vector2.ZERO
var velocity := Vector2.ZERO


func _ready() -> void:
	if district_resource:
		set_card_name(district_resource.district_name)
		set_card_cost(district_resource.cost)
		var card_color = district_resource.color
		if not card_color == "Purple":
			set_card_background(get_card_background_region_x(card_color))
		
		if district_resource.is_purple_foil:
			enable_foil()
			set_card_ability(district_resource.ability_text)
	
	# new
	previous_position = global_position


func _process(_delta: float) -> void:
	#handle_tilt(_delta)
	if is_purple_foil:
		enable_foil()


func set_card_name(card_name : String) -> void:
	$Front/CardNameLabel.text = card_name


func set_card_cost(cost : int) -> void:
	$Front/CardCostLabel.text = str(cost)


func set_card_ability(ability_text : String) -> void:
	$Front/CardAbilityLabel.text = ability_text
	$Front/CardAbilityLabel.visible = true


func enable_foil() -> void:
	is_purple_foil = true
	$Front/CardFrameSprite.modulate = Color(1, 0, 1, 255)
	$Front/FoilCardFXSprite.visible = true
	$Front/CardAbilityFrameSprite.visible = true


func get_card_background_region_x(color : String) -> float:
	var result = CardBackgroundRegionX.get(color)
	if result != null:
		return CardBackgroundRegionX.get(color)
	else:
		#print("no background region found")
		return CardBackgroundRegionX.get("Gray")


func set_card_background(color : float) -> void:
	$Front/CardFrameSprite.region_rect = Rect2(color, 0.0, 100.0, 128.0)


# new


func start_is_draggin_animation() -> void:
	$AnimationPlayer.play("is_dragging")


func reverse_is_draggin_animation() -> void:
	$AnimationPlayer.play_backwards("is_dragging")


func handle_tilt(delta : float) -> void:
	velocity = global_position - previous_position
	
	if velocity.length() > 1:
		var tilt = clamp(velocity.x * tilt_strength, -max_tilt_angle, max_tilt_angle)
		rotation_degrees = lerp(rotation_degrees, tilt, delta * tilt_smoothing)
	else:
		rotation_degrees = lerp(rotation_degrees, 0.0, delta * tilt_smoothing)
	previous_position = global_position


func play_flip_animation() -> void:
	$AnimationPlayer.play("flip")


func play_is_highlighted_animation() -> void:
	$AnimationPlayer.play("is_highlighted")


func play_is_highlighted_animation_backwards() -> void:
	$AnimationPlayer.play_backwards("is_highlighted")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_being_dragged: return
	GameEvents.card_hovered.emit(self, (area.get_parent() as DistrictCard))


func _on_area_2d_area_exited(area: Area2D) -> void:
	GameEvents.card_hovered_off.emit(self, (area.get_parent() as DistrictCard))


func _on_area_2d_mouse_entered() -> void:
	if GameData.card_being_dragged:
		return
	#play_is_highlighted_animation()
	is_highlighted = true

func _on_area_2d_mouse_exited() -> void:
	if GameData.card_being_dragged:
		return
	#play_is_highlighted_animation_backwards()
	is_highlighted = false

func disable_collider() -> void:
	$Area2D/CollisionShape2D.disabled = true


func enable_collider() -> void:
	$Area2D/CollisionShape2D.disabled = false
