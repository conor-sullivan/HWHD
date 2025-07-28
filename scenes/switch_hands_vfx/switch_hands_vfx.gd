class_name SwitchHandsVFX extends Node3D


func _ready() -> void:
	GameEvents.do_switch_hands_vfx.connect(do_switch_hands)


func do_switch_hands() -> void:
	print('yes')
	$AnimationPlayer.play("do_fx")
