extends MarginContainer


#region vars
@onready var pawns = $HBox/VBox/Pawns
@onready var temporary = $HBox/VBox/Tokens/Permanent
@onready var permanent = $HBox/VBox/Tokens/Temporary
@onready var chance = $HBox/Indicators/Chance
@onready var amount = $HBox/Indicators/Amount
@onready var limit = $HBox/Indicators/Limit

var croupier = null
var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	croupier = input_.croupier
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_indicators()


func init_indicators() -> void:
	var types = ["amount", "limit", "chance"]
	
	for type in types:
		var input = {}
		input.combo = self
		input.type = type
		
		var indicator = get(type)
		indicator.set_attributes(input)
	
	limit.value.set_number(Global.num.apotheosis.amount)
#endregion


func add_pawn(card_: MarginContainer) -> void:
	var input = {}
	input.combo = self
	input.card = card_
	
	var pawn = Global.scene.pawn.instantiate()
	pawns.add_child(pawn)
	pawn.set_attributes(input)
	


func update_amount(value_: int) -> void:
	amount.value.change_number(value_)
	
	if fiasco_check():
		#print(["fiasco", god.health.index.subtype])
		croupier.set_loser(god)
		chance.value.set_number(100)
	else:
		calculate_chance_of_fiasco()


func fiasco_check() -> bool:
	return amount.value.get_number() > limit.value.get_number()


func calculate_chance_of_fiasco() -> void:
	var overabundance = limit.value.get_number() - amount.value.get_number() + 1
	var outcomes = {}
	outcomes.total = god.gameboard.available.cards.get_child_count()
	outcomes.success = 0
	outcomes.failure = 0
	
	for card in god.gameboard.available.cards.get_children():
		if card.rank < overabundance:
			outcomes.success += 100.0 / outcomes.total
	
	outcomes.failure = 100.0 - outcomes.success
	#print([amount.value.get_number(), outcomes])
	chance.value.set_number(int(outcomes.failure))


func risk_assessment() -> void:
	if chance.value.get_number() < 50:
		god.gameboard.available.advance_random_card()
	else:
		lock_in()


func lock_in() -> void:
	croupier.locks.append(god)


func reset() -> void:
	croupier.locks.erase(god)
	var keys = ["amount", "chance"]
	
	for key in keys:
		var icon = get(key)
		icon.value.set_number(0)
	
	while pawns.get_child_count() > 0:
		var pawn = pawns.get_child(0)
		pawns.remove_child(pawn)
		pawn.queue_free()
