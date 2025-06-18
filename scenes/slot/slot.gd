class_name Slot
extends PanelContainer
#
#@export var item :
	##set(value):
		##item = value


func _on_panel_mouse_entered() -> void:
	(Popups as PopupsHandler).item_popup(Rect2i (Vector2i(global_position), Vector2i(size) ), null)


func _on_panel_mouse_exited() -> void:
	(Popups as PopupsHandler).hide_item_popup()
