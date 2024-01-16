extends MarginContainer


#region vars
@onready var available = $VBox/Cards/Available
@onready var discharged = $VBox/Cards/Discharged
@onready var broken = $VBox/Cards/Broken
@onready var hand = $VBox/Cards/Hand

var god = null
#endregion


func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	input_.gameboard = self
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	init_starter_kit_cards()
	
	for key in Global.dict.chain.area:
		if key != null:
			input_.type = key
			var cardstack = get(key)
			cardstack.set_attributes(input_)
	
	next_turn()


func init_starter_kit_cards() -> void:
	for suit in Global.arr.suit:
		for rank in Global.arr.rank:
			for _i in Global.dict.card.count:
				var input = {}
				input.gameboard = self
				input.rank = rank
				input.suit = suit
			
				var card = Global.scene.card.instantiate()
				discharged.cards.add_child(card)
				card.set_attributes(input)
				card.gameboard = self
				card.advance_area()
				#print([card.get_index(), suit, rank])
	
	#print("___")
	#reshuffle_available()



func next_turn() -> void:
	hand.refill()
