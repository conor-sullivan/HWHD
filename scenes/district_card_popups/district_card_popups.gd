class_name DistrictPopupsHandler
extends Control

var coins_created : bool = false


func _ready() -> void:
	GameEvents.district_card_destroyed_by_warlord.connect(_on_district_card_destroyed_by_warlord)


func item_popup(_slot, sprite_texture : Texture, coin_cost : int) -> void:
	$CanvasLayer/CardSprite2D.texture = sprite_texture
	if not coins_created:
		$CanvasLayer/CostSprite2D/Label.text = str(coin_cost)
		coins_created = true
	$CanvasLayer/CardSprite2D.show()
	$CanvasLayer/CostSprite2D.show()


func hide_item_popup() -> void:
	$CanvasLayer/CardSprite2D.hide()
	$CanvasLayer/CostSprite2D.hide()
	coins_created = false


func _on_district_card_destroyed_by_warlord(_player, _card) -> void:
	hide_item_popup()
