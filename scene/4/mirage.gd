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


func compliance_check() -> bool:
	var flag = true
	
	return flag


func cord_check() -> bool:
	
	
	return true


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
		#if socket.index.get_number() == 7:
			#print([mirage.flips.get_number(), mirage.turns.get_number()])
		
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
	
	
	#if socket.index.get_number() == 7:
	#	print(indexs)
	
	for _i in range(indexs[self].keys().size() -1, -1, -1):
		var flag = true
		
		for _j in range(indexs[mirage_].keys().size() -1, -1, -1):#indexs[mirage_].keys().size():
			var trefoil_a = indexs[self].keys()[_i]
			var trefoil_b = indexs[mirage_].keys()[_j]
			var indexs_a = indexs[self][trefoil_a]
			var indexs_b = indexs[mirage_][trefoil_b]
			
			#if socket.index.get_number() == 7:
			#	print(indexs_a, indexs_b)
			
			for _k in indexs_a.size():
				if indexs_a[_k] != indexs_b[_k]:
					flag = false
			
			if flag:
				indexs[self].erase(trefoil_a)
				indexs[mirage_].erase(trefoil_b)
				#if socket.index.get_number() == 7:
				#	print("@")
				break
	
	#if socket.index.get_number() == 7 and indexs[self].keys().is_empty(): 
		#print("!")
	return indexs[self].keys().is_empty()


func cords_repetition_check(mirage_: MarginContainer) -> bool:
	var mirages = [self, mirage_]
	var stars = {}
	var cords = {}
	
	for mirage in mirages:
		stars[mirage] = {}
		cords[mirage] = {}
		if socket.index.get_number() == 7:
			print([mirage.flips.get_number(), mirage.turns.get_number()])
		
		for trefoil in mirage.fusion.trefoils:
			stars[mirage][trefoil] = []
			
			for star in trefoil.stars:
				var _star = star
				
				for _i in mirage.flips.get_number():
					_star = fusion.proprietor.flips.star[_star]
				
				for _i in mirage.turns.get_number():
					_star = fusion.proprietor.turns.star["clockwise"][_star]
				
				stars[mirage][trefoil].append(_star)
	
	for mirage in mirages:
		for trefoil in mirage.fusion.trefoils:
			var _cords = sky.get_cords_based_on_stars(stars[mirage][trefoil])
			
			for cord in _cords:
				cords[mirage][cord] = trefoil
			#for _i in stars[mirage][trefoil].size():
				#var star_a = stars[mirage][trefoil][_i]
				#var _j = (_i + 1) % stars[mirage][trefoil].size()
				#var star_b = stars[mirage][trefoil][_j]
				#
				#if star_a.neighbors.has(star_b):
					#var cord = star_a.neighbors[star_b]
					#cords[mirage][cord] = trefoil
	
	if socket.index.get_number() == 7:
		for key in cords:
			print("___", key)
			
			for cord in cords[key]:
				print(cord.index.get_number())
	
	for _i in cords[self].keys().size():
		var cord = cords[self].keys()[_i]
		
		if !cords[mirage_].has(cord):
			if socket.index.get_number() == 7:
				print(cord.index.get_number(), " is single")
		
			return false
		
		if cords[self][cord].vocation != cords[mirage_][cord].vocation:
			if socket.index.get_number() == 7:
				print(cord.index.get_number(), " diffrent vocation")
			return false
	
	if socket.index.get_number() == 7:
		print("match")
	return true
