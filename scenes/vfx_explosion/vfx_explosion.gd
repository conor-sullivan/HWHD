class_name VFXExplosion extends Node3D

func start() -> void:
	$AnimationPlayer.play("init")
	GameEvents.requested_camera_shake.emit(0.2, 0.2)
