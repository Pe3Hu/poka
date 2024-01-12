extends MarginContainer


@onready var index = $VBox/Index
@onready var consumers = $VBox/Consumers
@onready var suppliers = $VBox/Suppliers

var proprietor = null
var cords = []
var stars = []
var trefoils = []
var gaps = []


func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	cords = input_.cords
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_index()
	init_stars()
	init_trefoils()


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


func init_trefoils() -> void:
	var _stars = []
	
	for star in proprietor.cycle:
		if stars.has(star):
			_stars.append(star)
			
			if _stars.size() == 3:
				if !check_stars_on_one_side(_stars):
					add_trefoil(_stars)
				
				_stars.pop_at(1)
	
	merge_trefoils()


func merge_trefoils() -> void:
	var _i = trefoils.size() - 1
	
	while _i > 0:
		var first = trefoils[_i]
		var second = trefoils[_i - 1]
		var pair = [first, second]
		
		if check_trefoils_on_rectangular(pair):
			first.merge_with(second)
			_i -= 1
		
		_i -= 1
	
	for gap in gaps:
		for trefoil in trefoils:
			if trefoil.index.get_number() > gap:
				trefoil.index.change_number(-1)
			
		Global.num.index.trefoil -= 1


func add_trefoil(stars_: Array) -> void:
	var input = {}
	input.constellation = self
	input.stars = []
	input.stars.append_array(stars_)
	
	var trefoil = Global.scene.trefoil.instantiate()
	proprietor.trefoils.add_child(trefoil)
	trefoil.set_attributes(input)


func check_stars_on_one_side(stars_: Array) -> bool:
	var sides = {}
	
	for star in stars_:
		for side in star.sides:
			if !sides.has(side):
				sides[side] = 0
			
			sides[side] += 1
	
	for side in sides:
		if sides[side] == stars_.size():
			return true
	
	return false


func check_trefoils_on_rectangular(trefoils_: Array) -> bool:
	var repeats = {}
	var singles = []
	
	for trefoil in trefoils_:
		for star in trefoil.stars:
			if !repeats.has(star):
				repeats[star] = 0
			
			repeats[star] += 1
	
	for star in repeats.keys():
		if repeats[star] != 2:
			singles.append(star)
			#print("single", star.index.get_number())
	
	for star in repeats:
		if repeats[star] == 2:
			#print("pair", star.index.get_number())
			var triplet = [star]
			triplet.append_array(singles)
			
			if check_stars_on_one_side(triplet):
				return true
	
	return false
