extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(-570, 0), 2)
	tween.tween_property(self, "position", Vector2(0, 0), 2)
	
	tween.set_loops(0)
