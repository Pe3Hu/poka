extends MarginContainer


@onready var cards = $Cards

var gameboard = null
var type = null
var capacity = {}


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	type = input_.type
	
	capacity.current = 6
	capacity.limit = 10


func refill() -> void:
	var cardstack = gameboard.get(Global.dict.donor.area[type])
	
	while cards.get_child_count() < capacity.current:
		cardstack.advance_random_card()


func discard() -> void:
	while cards.get_child_count() > 0:
		var card = cards.get_child(0)
		card.advance_area()
