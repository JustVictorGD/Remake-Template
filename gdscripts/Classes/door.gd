extends StaticBody2D
class_name Door

## When the door is opened, it opens by moving in this direction.
@export var direction: DoorDirection = DoorDirection.UP

## In the TWHG Remake Template, doors can't actually be scaled like you think they would.
## Instead, you should change values in this export variable.
## The size is measured in tiles, the size of each tile is 50x50 pixels.
@export var size = Vector2i(1, 1)

## If the door is opened while the player is in another area, the game will play a short cutscene to show the door opening.
@export var play_cutscene = true

@onready var outline = get_node("Outline")
@onready var filling = get_node("Filling")
@onready var collision_shape = get_node("CollisionShape2D")

enum DoorDirection {
	## Moves towards its top edge when opening
	UP,
	## Moves towards its left edge when opening
	LEFT,
	## Moves towards its bottom edge when opening
	DOWN,
	## Moves towards its right edge when opening
	RIGHT,
}

var closing_speed = 0.5
var opening_speed = 0.75

var opened = false

func setup_size():
	outline.scale = size * 50 + Vector2i(6, 6)
	filling.scale = size * 50 - Vector2i(6, 6)
	collision_shape.scale = size * 25 + Vector2i(3, 3)


func close():
	if opened:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		
		tween.parallel().tween_property(outline, "scale", Vector2(size) * 50 + Vector2(6, 6), closing_speed)
		tween.parallel().tween_property(outline, "position", Vector2.ZERO, closing_speed)
		
		tween.parallel().tween_property(filling, "scale", Vector2(size) * 50 - Vector2(6, 6), closing_speed)
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
			
			tween.parallel().tween_property(filling, "scale", Vector2(filling.scale.x, filling.scale.y - size.y * 50), opening_speed)
			tween.parallel().tween_property(filling, "position", Vector2(0, size.y * -25), opening_speed)
			
			tween.parallel().tween_property(outline, "scale", Vector2(outline.scale.x, outline.scale.y - size.y * 50), opening_speed)
			tween.parallel().tween_property(outline, "position", Vector2(0, size.y * -25), opening_speed)
		
		if direction == 1:
			
			tween.parallel().tween_property(filling, "scale", Vector2(filling.scale.x - size.x * 50, filling.scale.y), opening_speed)
			tween.parallel().tween_property(filling, "position", Vector2(size.x * -25, 0), opening_speed)
			
			tween.parallel().tween_property(outline, "scale", Vector2(outline.scale.x - size.x * 50, outline.scale.y), opening_speed)
			tween.parallel().tween_property(outline, "position", Vector2(size.x * -25, 0), opening_speed)
		
		if direction == 2:
			
			tween.parallel().tween_property(filling, "scale", Vector2(filling.scale.x, filling.scale.y - size.y * 50), opening_speed)
			tween.parallel().tween_property(filling, "position", Vector2(0, size.y * 25), opening_speed)
			
			tween.parallel().tween_property(outline, "scale", Vector2(outline.scale.x, outline.scale.y - size.y * 50), opening_speed)
			tween.parallel().tween_property(outline, "position", Vector2(0, size.y * 25), opening_speed)
		
		if direction == 3:
			
			tween.parallel().tween_property(filling, "scale", Vector2(filling.scale.x - size.x * 50, filling.scale.y), opening_speed)
			tween.parallel().tween_property(filling, "position", Vector2(size.x * 25, 0), opening_speed)
			
			tween.parallel().tween_property(outline, "scale", Vector2(outline.scale.x - size.x * 50, outline.scale.y), opening_speed)
			tween.parallel().tween_property(outline, "position", Vector2(size.x * 25, 0), opening_speed)


func stay_open():
	collision_shape.set_deferred("disabled", true)
	opened = true
	
	if direction == 0:
		
		filling.scale = Vector2(filling.scale.x, filling.scale.y - size.y * 50)
		filling.position = Vector2(0, size.y * -25)
		
		outline.scale = Vector2(outline.scale.x, outline.scale.y - size.y * 50)
		outline.position = Vector2(0, size.y * -25)
	
	if direction == 1:
		
		filling.scale = Vector2(filling.scale.x - size.x * 50, filling.scale.y)
		filling.position = Vector2(size.x * -25, 0)
		
		outline.scale = Vector2(outline.scale.x - size.x * 50, outline.scale.y)
		outline.position = Vector2(size.x * -25, 0)
	
	if direction == 2:
		
		filling.scale = Vector2(filling.scale.x, filling.scale.y - size.y * 50)
		filling.position = Vector2(0, size.y * 25)
		
		outline.scale = Vector2(outline.scale.x, outline.scale.y - size.y * 50)
		outline.position = Vector2(0, size.y * 25)
	
	if direction == 3:
		
		filling.scale = Vector2(filling.scale.x - size.x * 50, filling.scale.y)
		filling.position = Vector2(size.x * 25, 0)
		
		outline.scale = Vector2(outline.scale.x - size.x * 50, outline.scale.y)
		outline.position = Vector2(size.x * 25, 0)
