extends Area2D

@export_category("Object Settings")
@export var speed = 4 # 4 is the default player speed.

func touched_by_player():
	GlobalSignal.speed_changed.emit(speed)
