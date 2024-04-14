extends StaticBody2D
class_name Door

@export_category("Door Size")
@export var direction = 0
@export var horizontal_size = 1
@export var vertical_size = 1

@onready var outline = get_node("Outline")
@onready var filling = get_node("Filling")
@onready var collision_shape = get_node("CollisionShape2D")


var closing_speed = 0.5
var opening_speed = 0.75

var opened = false

func setup_size():
	outline.scale = Vector2(horizontal_size, vertical_size) * 50 + Vector2(6, 6)
	filling.scale = Vector2(horizontal_size, vertical_size) * 50 - Vector2(6, 6)
	collision_shape.scale = Vector2(horizontal_size, vertical_size) * 25 + Vector2(3, 3)


func close():
	if opened:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		
		tween.parallel().tween_property(outline, "scale", Vector2(horizontal_size, vertical_size) * 50 + Vector2(6, 6), closing_speed)
		tween.parallel().tween_property(outline, "position", Vector2.ZERO, closing_speed)
		
		tween.parallel().tween_property(filling, "scale", Vector2(horizontal_size, vertical_size) * 50 - Vector2(6, 6), closing_speed)
		tween.parallel().tween_property(filling, "position", Vector2.ZERO, closing_speed)
		SFX.play("CloseDoor")
		collision_shape.set_deferred("disabled", false)
		
		opened = false


func open():
	if not opened:
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		SFX.play("OpenDoor")
		collision_shape.set_deferred("disabled", true)
		
		opened = true
		
		if direction == 0:
			
			tween.parallel().tween_property(filling, "scale", Vector2(filling.scale.x, filling.scale.y - vertical_size * 50), opening_speed)
			tween.parallel().tween_property(filling, "position", Vector2(0, vertical_size * -25), opening_speed)
			
			tween.parallel().tween_property(outline, "scale", Vector2(outline.scale.x, outline.scale.y - vertical_size * 50), opening_speed)
			tween.parallel().tween_property(outline, "position", Vector2(0, vertical_size * -25), opening_speed)
		
		if direction == 1:
			
			tween.parallel().tween_property(filling, "scale", Vector2(filling.scale.x - horizontal_size * 50, filling.scale.y), opening_speed)
			tween.parallel().tween_property(filling, "position", Vector2(horizontal_size * -25, 0), opening_speed)
			
			tween.parallel().tween_property(outline, "scale", Vector2(outline.scale.x - horizontal_size * 50, outline.scale.y), opening_speed)
			tween.parallel().tween_property(outline, "position", Vector2(horizontal_size * -25, 0), opening_speed)
		
		if direction == 2:
			
			tween.parallel().tween_property(filling, "scale", Vector2(filling.scale.x, filling.scale.y - vertical_size * 50), opening_speed)
			tween.parallel().tween_property(filling, "position", Vector2(0, vertical_size * 25), opening_speed)
			
			tween.parallel().tween_property(outline, "scale", Vector2(outline.scale.x, outline.scale.y - vertical_size * 50), opening_speed)
			tween.parallel().tween_property(outline, "position", Vector2(0, vertical_size * 25), opening_speed)
		
		if direction == 3:
			
			tween.parallel().tween_property(filling, "scale", Vector2(filling.scale.x - horizontal_size * 50, filling.scale.y), opening_speed)
			tween.parallel().tween_property(filling, "position", Vector2(horizontal_size * 25, 0), opening_speed)
			
			tween.parallel().tween_property(outline, "scale", Vector2(outline.scale.x - horizontal_size * 50, outline.scale.y), opening_speed)
			tween.parallel().tween_property(outline, "position", Vector2(horizontal_size * 25, 0), opening_speed)


func stay_open():
	collision_shape.set_deferred("disabled", true)
	opened = true
	
	if direction == 0:
		
		filling.scale = Vector2(filling.scale.x, filling.scale.y - vertical_size * 50)
		filling.position = Vector2(0, vertical_size * -25)
		
		outline.scale = Vector2(outline.scale.x, outline.scale.y - vertical_size * 50)
		outline.position = Vector2(0, vertical_size * -25)
	
	if direction == 1:
		
		filling.scale = Vector2(filling.scale.x - horizontal_size * 50, filling.scale.y)
		filling.position = Vector2(horizontal_size * -25, 0)
		
		outline.scale = Vector2(outline.scale.x - horizontal_size * 50, outline.scale.y)
		outline.position = Vector2(horizontal_size * -25, 0)
	
	if direction == 2:
		
		filling.scale = Vector2(filling.scale.x, filling.scale.y - vertical_size * 50)
		filling.position = Vector2(0, vertical_size * 25)
		
		outline.scale = Vector2(outline.scale.x, outline.scale.y - vertical_size * 50)
		outline.position = Vector2(0, vertical_size * 25)
	
	if direction == 3:
		
		filling.scale = Vector2(filling.scale.x - horizontal_size * 50, filling.scale.y)
		filling.position = Vector2(horizontal_size * 25, 0)
		
		outline.scale = Vector2(outline.scale.x - horizontal_size * 50, outline.scale.y)
		outline.position = Vector2(horizontal_size * 25, 0)
