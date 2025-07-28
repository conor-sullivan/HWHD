class_name DaggerAttack extends Node3D

@onready var blood= $BloodSplash


func _ready() -> void:
	GameEvents.do_player_assassinate_vfx.connect(do_attack)


func show_blood() -> void:
	GameEvents.requested_camera_shake.emit(0.3, 0.1)
	blood.activate_effects()


func do_attack() -> void:
	show()
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	hide()
