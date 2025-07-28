class_name GodRaysOpponent extends Node3D


func _ready() -> void:
	GameEvents.do_god_rays_opponent_vfx.connect(do_god_rays)

func do_god_rays() -> void:
	$AnimationPlayer.play("do_god_rays")
