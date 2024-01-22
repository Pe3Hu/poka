extends MarginContainer


#region vars
@onready var bg = $BG
@onready var suit = $VBox/Suit
@onready var tokens = $VBox/Tokens

var area = null
var gameboard = null
var rank = null
var performer = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	rank = input_.rank
	performer = input_.performer
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.card = self
	suit.set_attributes(input)
	#set_selected(false)
	roll_tokens()


func roll_tokens() -> void:
	var points = int(rank)
	var description = Global.dict.performer.token[performer]
	var weights = {}
	
	for token in description:
		var data = description[token]
		
		if points >= data.weight:
			if !weights.has(data.weight):
				weights[data.weight] = []
			
			weights[data.weight].append(token)
		
	var ordered = weights.keys()
	ordered.sort()
	var values = {}
	
	while points > 0 and !ordered.is_empty():
		var weight = ordered.back()
		var token = weights[weight].pick_random()
		
		if !values.has(token):
			values[token] = 0
		
		values[token] += description[token].value
		points -= description[token].weight
		
		if points > 0:
			while ordered.back() > points:
				ordered.pop_back()
	
	for appellation in values:
		var input = {}
		input.card = self
		input.appellation = appellation
		input.stack = values[appellation]
		input.target = description[appellation].target
	
		var token = Global.scene.token.instantiate()
		tokens.add_child(token)
		token.set_attributes(input)
#endregion


func set_selected(selected_: bool) -> void:
	var style = bg.get("theme_override_styles/panel")
	
	match selected_:
		true:
			style.bg_color = Global.color.card.selected
			pass
		false:
			style.bg_color = Global.color.card.unselected


func advance_area() -> void:
	var cardstack = null
	
	if area == null:
		area = Global.dict.chain.area[area]
		advance_area()
	else:
		cardstack = gameboard.get(area)
		cardstack.cards.remove_child(self)
	
		area = Global.dict.chain.area[area]
		cardstack = gameboard.get(area)
		cardstack.cards.add_child(self)
	
	if area == "hand" and gameboard.god.combo != null:
		gameboard.god.combo.add_pawn(self)
