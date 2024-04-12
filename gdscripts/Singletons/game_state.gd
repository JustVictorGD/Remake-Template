extends Node


var finish_touched = false
var respawn_pos = Vector2(250, 850)

var player_outline = Color8(102, 0, 0)
var player_filling = Color8(255, 0, 0)


var uncollected_coins = []
var collected_coins = []
var saved_coins = []

var coin_data = [uncollected_coins, collected_coins, saved_coins]



var next_coin_id = 0
var coin_requirement = 0
var requirement_met = false

func get_next_id():
	next_coin_id += 1
	coin_requirement += 1

func _physics_process(delta):
	if collected_coins.size() + saved_coins.size() >= coin_requirement:
		
		if not requirement_met:
			requirement_met = true
			GlobalSignal.coin_requirement_met.emit()
			print("OPEN, GOLDEN DOOR.")
	
	else:
		if requirement_met:
			requirement_met = false
			GlobalSignal.coin_requirement_lost.emit()
			print("CLOSE, GOLDEN DOOR.")
	
	#print_stuff()

func print_stuff():
	print("Uncollected coins: " + str(uncollected_coins))
	print("Collected coins: " + str(collected_coins))
	print("Saved coins: " + str(saved_coins))
	print()
	print("Coin Requirement - " + str(coin_requirement))
	print()
