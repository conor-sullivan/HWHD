class_name InBattleActionSelection
extends Control

@export var default_scale = 0.8
@export var scale_multiplier = 1.1


func _on_gold_option_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%GoldOption, "scale", Vector2.ONE * default_scale * scale_multiplier, 0.2)


func _on_gold_option_mouse_exited() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%GoldOption, "scale", Vector2.ONE * default_scale, 0.2)


func _on_card_option_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%CardOption, "scale", Vector2.ONE * default_scale * scale_multiplier, 0.2)


func _on_card_option_mouse_exited() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%CardOption, "scale", Vector2.ONE * default_scale, 0.2)
