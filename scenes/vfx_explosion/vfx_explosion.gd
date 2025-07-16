class_name VFXExplosion extends Node3D

func start() -> void:
	$AnimationPlayer.play("init")
	await $AnimationPlayer.animation_finished
