extends MarginContainer


@onready var bg = $BG
@onready var sky = $VBox/HBox/Sky
@onready var soil = $VBox/HBox/Soil

var god = null


func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.vastness = self
	sky.set_attributes(input)
	soil.set_attributes(input)
	#river.set_attributes(input)
