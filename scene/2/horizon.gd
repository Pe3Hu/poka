extends MarginContainer


@onready var constellations = $HBox/Constellations
@onready var sky = $HBox/Sky

var vastness = null


func set_attributes(input_: Dictionary) -> void:
	vastness = input_.vastness
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.horizon = self
	sky.set_attributes(input)
