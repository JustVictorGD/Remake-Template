extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	
	tween.tween_property(self, "position", Vector2(150, 0), 0.35)
	tween.tween_property(self, "position", Vector2(150, 150), 0.35)
	tween.tween_property(self, "position", Vector2(0, 150), 0.35)
	tween.tween_property(self, "position", Vector2(0, 0), 0.35)
	
	tween.set_loops(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
