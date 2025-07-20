extends Camera3D

var shake_strength := 0.2
var shake_duration := 0.3
var shake_timer := 0.0
var original_position := Vector3.ZERO

func _ready():
	original_position = global_position
	GameEvents.requested_camera_shake.connect(_on_requested_camera_shake)

func _on_requested_camera_shake(strength := 0.2, duration := 0.3):
	shake_strength = strength
	shake_duration = duration
	shake_timer = duration

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		global_position = original_position + Vector3(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength) * 0.5
		)
	else:
		global_position = original_position
