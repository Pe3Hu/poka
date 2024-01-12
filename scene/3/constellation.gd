extends MarginContainer


@onready var index = $VBox/Index
@onready var consumers = $VBox/Consumers
@onready var suppliers = $VBox/Suppliers

var proprietor = null
var cords = []
var stars = []


func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	cords = input_.cords
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_index()
	init_stars()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.constellation
	index.set_attributes(input)
	Global.num.index.constellation += 1


func init_stars() -> void:
	for cord in cords:
		for star in cord.stars:
			if !stars.has(star):
				stars.append(star)
	
	var _stars = []
	
	for star in proprietor.cycle:
		if stars.has(star):
			_stars.append(star)
			
			if _stars.size() == 3:
				add_trefoil(_stars)
				_stars.pop_at(1)


func add_trefoil(stars_: Array) -> void:
	var input = {}
	input.constellation = self
	input.stars = stars_
	
	var trefoil = Global.scene.trefoil.instantiate()
	proprietor.trefoils.add_child(trefoil)
	trefoil.set_attributes(input)
