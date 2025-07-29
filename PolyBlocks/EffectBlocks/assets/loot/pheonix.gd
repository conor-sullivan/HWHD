extends Node3D


func show_fx() -> void:
	$Sparkles.emitting = true
	$GroundEffect_1.show()
	$Pheonix.emitting = true
	
	await get_tree().create_timer(1).timeout
	
	#$Sparkles.emitting = false
	#$GroundEffect_1.hide()
	#$Pheonix.emitting = false
