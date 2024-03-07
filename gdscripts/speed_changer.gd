extends Area2D

@export_category("Object Settings")
@export var speed = 4 # 4 is the default player speed.

func _ready():
	if speed > 4:
		$Texture.texture = load("res://pngs and svgs/speed_changer_placeholder-fast.png")
	if speed == 4:
		$Texture.texture = load("res://pngs and svgs/speed_changer_placeholder-normal.png")
	if speed < 4:
		$Texture.texture = load("res://pngs and svgs/speed_changer_placeholder.png")

func touched_by_player():
	GlobalSignal.speed_changed.emit(speed)
