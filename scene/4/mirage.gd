extends MarginContainer


#region vars
@onready var fusionIndex = $HBox/Fusion
@onready var socketIndex = $HBox/Socket
@onready var turns = $HBox/Turns
@onready var flips = $HBox/Flips

var oasis = null
var fusion = null
var socket = null
#endregion

#region init
func set_attributes(input_: Dictionary) -> void:
	oasis = input_.oasis
	fusion = input_.fusion
	socket = input_.socket
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_indexs()
	init_turns_and_flips(input_)


func init_indexs() -> void:
	var input = {}
	input.type = "number"
	input.subtype = fusion.index.get_number()
	fusionIndex.set_attributes(input)
	
	input.subtype = socket.index.get_number()
	socketIndex.set_attributes(input)


func init_turns_and_flips(input_: Dictionary) -> void:
	var input = {}
	input.type = "number"
	input.subtype = input_.flips
	flips.set_attributes(input)
	
	input.subtype = input_.turns
	turns.set_attributes(input)
#endregion


