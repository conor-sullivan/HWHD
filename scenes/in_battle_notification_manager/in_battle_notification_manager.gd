extends CanvasLayer

var notification_scene = preload("res://scenes/in_battle_notification_manager/in_battle_notification.tscn")
var notification_queue = []


func _ready() -> void:
	GameEvents.requested_new_in_battle_notification.connect(_on_requested_new_in_battle_notification)


func show_notification(attacker: String, _icon: Texture2D, action: String, target: String) -> void:
	var notif = notification_scene.instantiate()
	notif.get_node("AttackerLabel").text = attacker	
	#    notif.get_node("Icon").texture = icon
	notif.get_node("ActionLabel").text = action
	notif.get_node("TargetLabel").text = target
	$NotificationVBox.add_child(notif)
	
	# Animate in
	notif.modulate.a = 0
	notif.create_tween().tween_property(notif, "modulate:a", 1, 0.3)
	
	# Animate out after 2 seconds
	await get_tree().create_timer(2.0).timeout
	notif.create_tween().tween_property(notif, "modulate:a", 0, 0.3)
	await get_tree().create_timer(0.3).timeout
	notif.queue_free()


func _on_requested_new_in_battle_notification(attacker_name : String, _icon_texture : Texture, action : String, target_name : String):
	show_notification(attacker_name, _icon_texture, action, target_name)
