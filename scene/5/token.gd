extends MarginContainer


#region vars
@onready var bg = $BG
@onready var target = $Target
@onready var appellation = $Appellation
@onready var stack = $Stack

var card = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	card = input_.card
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.type = "token"
	input.subtype = input_.appellation
	appellation.set_attributes(input)
	
	input.type = "target"
	input.subtype = input_.target
	target.set_attributes(input)
	
	input.type = "number"
	input.subtype = input_.stack
	stack.set_attributes(input)
	
	var gap = 8
	appellation.set("theme_override_constants/margin_left", gap)
	appellation.set("theme_override_constants/margin_top", gap)
	stack.set("theme_override_constants/margin_right", gap)
	stack.set("theme_override_constants/margin_bottom", gap)
#endregion
