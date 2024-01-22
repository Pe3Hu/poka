extends MarginContainer


#region vars
@onready var icon = $HBox/Icon
@onready var value = $HBox/Value

var combo = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	combo = input_.combo
	type = input_.type
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.type = "number"
	input.subtype = 0
	value.set_attributes(input)
	
	input.type = "indicator"
	input.subtype = type
	icon.set_attributes(input)
#endregion
