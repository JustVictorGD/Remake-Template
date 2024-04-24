extends Node2D

@onready var area = get_node("area")
@onready var deaths = get_node("deaths")
@onready var coins = get_node("coins")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coins.text = ("$ " + str(AreaManager.coins_collected) + " / " + str(AreaManager.coin_requirement))
	deaths.text = ("Deaths: " + str(AreaManager.deaths))
	area.text = ("Area: " + str(AreaManager.current_level.get_slice("_", 1)) + "-" + str(AreaManager.decimal_to_letter(AreaManager.current_coordinates.x) + str(AreaManager.current_coordinates.y)))
