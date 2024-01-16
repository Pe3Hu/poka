extends MarginContainer


@onready var cards = $Cards

var gameboard = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	type = input_.type


func reshuffle_all_cards() -> void:
	var cards = []
	
	while cards.get_child_count() > 0:
		var card = cards.get_child(0)
		cards.remove_child(card)
		cards.append(card)
	
	cards.shuffle()
	
	for card in cards:
		cards.add_child(card)


func advance_random_card() -> void:
	refill_check()
	var card = cards.get_children().pick_random()
	card.advance_area()


func advance_all_cards() -> void:
	while cards.get_child_count() > 0:
		advance_random_card()


func refill_check() -> void:
	if cards.get_child_count() == 0:
		var donor = Global.dict.donor.area[type]
		var cardstack = gameboard.get(donor)
		cardstack.advance_all_cards()
