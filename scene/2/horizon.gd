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


func add_constellation(trefoils_: Array) -> void:
	var input = {}
	input.horizon = self
	input.trefoils = trefoils_
	
	var constellation = Global.scene.constellation.instantiate()
	constellations.add_child(constellation)
	constellation.set_attributes(input)
