class_name PlayerArchFX extends Node3D


@export var max_scale = 15

func _ready() -> void:
	GameEvents.do_player_arch_ability_vfx.connect(_on_do_player_arch_ability_vfx)


func _on_do_player_arch_ability_vfx() -> void:
	show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale",	Vector3.ONE * max_scale, 0.5) 
	tween.tween_interval(1)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(Callable(self, "hide"))
