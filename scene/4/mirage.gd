extends MarginContainer


#region vars
@onready var fusionIndex = $HBox/Fusion
@onready var socketIndex = $HBox/Socket
@onready var turns = $HBox/Turns
@onready var flips = $HBox/Flips

var oasis = null
var sky = null
var fusion = null
var socket = null
var cords = {}
#endregion

#region init
func set_attributes(input_: Dictionary) -> void:
	oasis = input_.oasis
	fusion = input_.fusion
	socket = input_.socket
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	sky = oasis.vastness.horizon.sky
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


#region checks
func repetition_check(mirage_: MarginContainer) -> bool:
	var flag = stars_repetition_check(mirage_)
	
	if !flag:
		flag = cords_repetition_check(mirage_)
		
	return flag 


func stars_repetition_check(mirage_: MarginContainer) -> bool:
	var mirages = [self, mirage_]
	var indexs = {}
	
	for mirage in mirages:
		indexs[mirage] = {}
		
		for trefoil in mirage.fusion.trefoils:
			indexs[mirage][trefoil] = []
			
			for star in trefoil.stars:
				var _star = star
				
				for _i in mirage.flips.get_number():
					_star = fusion.proprietor.flips.star[_star]
				
				for _i in mirage.turns.get_number():
					_star = fusion.proprietor.turns.star["clockwise"][_star]
				
				var index = _star.index.get_number()
				indexs[mirage][trefoil].append(index)
	
	for mirage in mirages:
		for trefoil in mirage.fusion.trefoils:
			indexs[mirage][trefoil].sort_custom(func(a, b): return a < b)
	
	
	for _i in range(indexs[self].keys().size() -1, -1, -1):
		var flag = true
		
		for _j in range(indexs[mirage_].keys().size() -1, -1, -1):
			var trefoil_a = indexs[self].keys()[_i]
			var trefoil_b = indexs[mirage_].keys()[_j]
			var indexs_a = indexs[self][trefoil_a]
			var indexs_b = indexs[mirage_][trefoil_b]
			
			for _k in indexs_a.size():
				if indexs_a[_k] != indexs_b[_k]:
					flag = false
			
			if flag:
				indexs[self].erase(trefoil_a)
				indexs[mirage_].erase(trefoil_b)
				break
	
	return indexs[self].keys().is_empty()


func cords_repetition_check(mirage_: MarginContainer) -> bool:
	var mirages = [self, mirage_]
	
	for mirage in mirages:
		mirage.fill_cords()
	
	for _i in cords.keys().size():
		var cord = cords.keys()[_i]
		
		if !mirage_.cords.has(cord):
			return false
		
		if cords[cord].vocation != mirage_.cords[cord].vocation:
			return false
	
	return true


func fill_cords() -> void:
	if cords.keys().is_empty():
		var stars = {}
		
		for trefoil in fusion.trefoils:
			stars[trefoil] = []
			
			for star in trefoil.stars:
				var _star = star
				
				for _i in flips.get_number():
					_star = fusion.proprietor.flips.star[_star]
				
				for _i in turns.get_number():
					_star = fusion.proprietor.turns.star["clockwise"][_star]
				
				stars[trefoil].append(_star)
		
		for trefoil in fusion.trefoils:
			var _cords = sky.get_cords_based_on_stars(stars[trefoil])
			
			for cord in _cords:
				if !cords.has(cord):
					cords[cord] = trefoil


func compliance_check() -> bool:
	var flag = cords_check()
	
	return flag


func cords_check() -> bool:
	if Global.num.index.fusion == 2:
		print([socket.index.get_number(), ">>>", flips.get_number(), turns.get_number()])
	var _cords = {}
	_cords.socket = socket.core.get_cords_around_socket_perimeter()
	_cords.fusion = fusion.proprietor.core.get_cords_around_socket_perimeter()
	
	for cord in _cords.fusion:
		if !cords.has(cord):
			cords[cord] = null
		else:
			cords[cord] = cords[cord].vocation
	
	for _i in _cords.socket.size():
		var cord = {}
		cord.socket = _cords.socket[_i]
		cord.fusion = _cords.fusion[_i]
		var vocation = null
		
		if cord.socket.status == "incomplete":
			if !cord.socket.trefoils.is_empty():
				vocation = cord.socket.trefoils.front().vocation
			
			if vocation != cords[cord.fusion]:
				if Global.num.index.fusion == 2:
					print(["???", cord.socket.index.get_number(), cord.fusion.index.get_number()])
				return false
			
	
	return true
#endregion
