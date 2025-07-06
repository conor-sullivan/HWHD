class_name DistrictCard2D extends Control


var data : DistrictData :
	set(value):
		data = value
		%CardSprite.texture = data.sprite_texture
		%CostLabel.text = data.cost

@export var is_selected : bool = false


func _ready():
	# Assuming the node has a material (e.g., ShaderMaterial)
	if %Shader.material:
		%Shader.material = %Shader.material.duplicate() # Create a unique copy of the material
		%Shader.set_material(%Shader.material) # Assign the unique material to this instance



func new_scale_tween() -> Tween:
	var tween : Tween = create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	return tween


func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print('pressed')

		if is_selected:
			$AnimationPlayer.play("card_unselected")
			is_selected = false
			position.y += 20
		else:
			$AnimationPlayer.play("card_selected")
			is_selected = true
			position.y -= 20
