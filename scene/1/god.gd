extends MarginContainer


@onready var vastness = $HBox/Vastness
@onready var gameboard = $HBox/Gameboard

var pantheon = null


func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.god = self
	vastness.set_attributes(input)
	gameboard.set_attributes(input)
