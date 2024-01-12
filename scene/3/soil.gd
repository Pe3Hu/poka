extends MarginContainer


@onready var constellations = $HBox/Constellations
@onready var subsoil = $HBox/Subsoil

var vastness = null


func set_attributes(input_: Dictionary) -> void:
	vastness = input_.vastness
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.vastness = self
	subsoil.set_attributes(input)
