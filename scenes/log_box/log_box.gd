class_name LogBox
extends Control


func _ready() -> void:
	GameEvents.requested_new_log_item.connect(add_new_item)


func add_new_item(log_data : String) -> void:
	var logs = $VBoxContainer.get_children()
	if logs.size() > 4:
		$VBoxContainer.remove_child(logs[0])
	
	var new_log = Label.new()
	new_log.text = log_data
	$VBoxContainer.add_child(new_log)
	
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.seek(0.2)
	else:
		$AnimationPlayer.play("make_visible_then_disappear")
