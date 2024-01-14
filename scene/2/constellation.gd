extends MarginContainer


#region vars
@onready var index = $VBox/Index

var horizon = null
var trefoils = null
var neighbors = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	horizon = input_.horizon
	trefoils = input_.trefoils
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_index()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.trefoil
	index.set_attributes(input)
	Global.num.index.trefoil += 1
#endregion

