class_name DistrictPopupsHandler
extends Control

var coins_created : bool = false


func item_popup(_slot, sprite_texture : Texture, coin_cost : int) -> void:
	$CanvasLayer/CardSprite2D.texture = sprite_texture
	if not coins_created:
		($CanvasLayer/DistrictCoinCostContainer as DistrictCoinCostContainer).create_coins(coin_cost)
		coins_created = true
	$CanvasLayer/CardSprite2D.show()


func hide_item_popup() -> void:
	$CanvasLayer/CardSprite2D.hide()
	coins_created = false
	($CanvasLayer/DistrictCoinCostContainer as DistrictCoinCostContainer).remove_all_coins()
