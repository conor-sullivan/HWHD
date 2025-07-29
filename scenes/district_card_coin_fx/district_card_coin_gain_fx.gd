extends Node3D

func _ready() -> void:
	$AnimationPlayer.play("do_fx")


func kill() -> void:
	call_deferred("queue_free")
