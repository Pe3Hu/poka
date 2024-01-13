extends MarginContainer


#region vars
@onready var index = $VBox/Index

var proprietor = null
var shape = null
var cords = []
var stars = []
var trefoils = []
var gaps = []
#endregion

#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	shape = input_.shape
	cords = input_.cords
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_index()
	init_stars()
	init_trefoils()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.fusion
	index.set_attributes(input)
	Global.num.index.fusion += 1


func init_stars() -> void:
	for cord in cords:
		for star in cord.stars:
			if !stars.has(star):
				stars.append(star)


func init_trefoils() -> void:
	var _stars = []
	
	if stars.size() == 2 or check_stars_on_one_side(stars):
		var repeats = {}
		
		for cord in cords:
			for star in cord.stars:
				if !repeats.has(star):
					repeats[star] = 0
				
				repeats[star] += 1
		
		for star in repeats:
			if repeats[star] == 2:
				stars.erase(star)
		
		stars.push_front(proprietor.decors.star)
		add_trefoil(stars)
	
	else:
		for star in proprietor.cycle:
			if stars.has(star):
				_stars.append(star)
				
				if _stars.size() == 3:
					if !check_stars_on_one_side(_stars):
						add_trefoil(_stars)
					
					_stars.pop_at(1)
	
	merge_trefoils()
	init_trefoils_neighbors()
	roll_trefoil_vocations()


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


func init_trefoils_neighbors() -> void:
	for _i in trefoils.size():
		for _j in range(_i + 1, trefoils.size(), 1):
			var trefoil = trefoils[_i]
			var neighbor = trefoils[_j]
			var _trefoils = [trefoil, neighbor]
			var repeats = {}
			var count = 0
			
			for _trefoil in _trefoils:
				for star in _trefoil.stars:
					if !repeats.has(star):
						repeats[star] = 0
					
					repeats[star] += 1
					
					if repeats[star] == 2:
						count += 1
			
			if count == 2:
				trefoil.neighbors.append(neighbor)
				neighbor.neighbors.append(trefoil)


func roll_trefoil_vocations() -> void:
	for trefoil in trefoils:
		trefoil.roll_vocation()
	
	var exceptions = ["rhomb", "trapeze", "rectangle"]
	
	if exceptions.has(shape):
		match trefoils.size():
			2:
				var trefoil = trefoils.pick_random()
				
				if trefoil.square == 2 or shape == "trapeze":
					revocation_from_neighbors(trefoil)
			3:
				for trefoil in trefoils:
					if trefoil.neighbors.size() == 2:
						revocation_from_neighbors(trefoil)


func add_trefoil(stars_: Array) -> void:
	var input = {}
	input.fusion = self
	input.stars = []
	input.stars.append_array(stars_)
	
	var trefoil = Global.scene.trefoil.instantiate()
	proprietor.trefoils.add_child(trefoil)
	trefoil.set_attributes(input)
#endregion


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
	
	for star in repeats:
		if repeats[star] == 2:
			var triplet = [star]
			triplet.append_array(singles)
			
			if check_stars_on_one_side(triplet):
				return true
	
	return false


func revocation_from_neighbors(trefoil_: Polygon2D) -> void:
	var neighbors = []
	neighbors.append_array(trefoil_.neighbors)
	neighbors.sort_custom(func(a, b): return a.square < b.square)
	
	var neighbor = neighbors.front()
	
	if neighbors.front().square == neighbors.back().square:
		neighbor = neighbors.pick_random()
	
	trefoil_.revocation_from(neighbor)


func turn(shift_: int) -> void:
	var index = (shift_ + 1 ) / 2
	var direction = Global.arr.turn[index]
	
	for trefoil in trefoils:
		trefoil.turn(direction)
