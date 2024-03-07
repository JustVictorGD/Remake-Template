extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(0, 370), 1)
	tween.tween_property(self, "position", Vector2(0, 0), 1)
	
	tween.set_loops(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
