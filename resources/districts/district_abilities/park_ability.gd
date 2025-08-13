extends BaseDistrictAbility
class_name ParkAbility

func on_end_of_turn(card: DistrictData, player: Player) -> void:
	"""If player has no cards in hand at end of turn, draw 2 cards"""
	if player.district_cards_in_hand.size() == 0:
		GameEvents.requested_player_draw_district_cards.emit(player, 2)
		emit_ability_notification(player, "drew 2 cards from Park ability")
