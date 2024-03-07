extends Node2D


func _ready():
	var tween = create_tween()
	
	tween.tween_property(self, "rotation", PI*2, 2.5)
	tween.tween_property(self, "rotation", 0, 0)
	
	tween.set_loops(0)
