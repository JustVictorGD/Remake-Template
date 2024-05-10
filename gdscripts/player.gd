extends CharacterBody2D

@export_category("Player Settings")
@export var speed = 4
var death = false

@export_category("Cheats")
@export var invincible = false # Should be false. Change to true for testing.
@export var can_teleport = false




func _ready():
	GlobalSignal.speed_changed.connect(speed_changed)
	GlobalSignal.finish.connect(finish)
	
	if AreaManager.player_previously_dead:
		var tween = create_tween()
		tween.tween_property($CanvasGroup,"self_modulate:a", 0, 0)
		tween.tween_property($CanvasGroup,"self_modulate:a", 1, 0.25)
		
		AreaManager.player_previously_dead = false


func _on_area_2d_area_entered(area):
	if "Enemies" in area.get_groups() and invincible == false:
		enemy_death()


func enemy_death():
	death = true
	invincible = true
	
	AreaManager.player_currently_dead = true
	
	var tween = create_tween()
	tween.tween_property($CanvasGroup,"self_modulate:a", 0, 0.50)
	SFX.play("EnemyDeath")
	$RespawnTimer.start()
	
	GlobalSignal.player_death.emit()


func pit_death():
	pass


func water_death():
	pass


func finish():
	var tween = create_tween()
	tween.tween_property($CanvasGroup,"self_modulate:a", 0, 1)
	
	invincible = true
	GameState.finish_touched = true
	
	SFX.play("Finish")



func _on_respawn_timer_timeout():
	
	AreaManager.player_currently_dead = false
	
	AreaManager.deaths += 1
	GlobalSignal.player_respawn.emit()
	
	if AreaManager.current_area_file_path == AreaManager.respawn["area_file_path"]:
		position = AreaManager.respawn["position"]
		
		death = false
		
		var tween = create_tween()
		tween.tween_property($CanvasGroup,"self_modulate:a", 1, 0.25)
		$Extra50ms.start()
	
	else:
		AreaManager.player_position = AreaManager.respawn["position"]
		AreaManager.player_previously_dead = true
		get_tree().change_scene_to_file(AreaManager.respawn["area_file_path"])

func _on_extra_100_ms_timeout():
	invincible = false


func _on_player_area_entered(area: Area2D):
	if area.has_method("touched_by_player"):
		area.touched_by_player()

func speed_changed(new_speed):
	speed = new_speed


func _physics_process(delta):
	if death == false:
		if Input.is_action_pressed("right"):
			position.x += speed
		
		if Input.is_action_pressed("down"):
			position.y += speed
		
		if Input.is_action_pressed("left"):
			position.x -= speed
		
		if Input.is_action_pressed("up"):
			position.y -= speed
	
	if Input.is_action_just_pressed("teleport") and can_teleport:
		position.x = get_global_mouse_position().x / (600.0 / (AreaManager.AREA_SIZE.y * 50)) - (160 / 0.6)
		position.y = get_global_mouse_position().y / (600.0 / (AreaManager.AREA_SIZE.y * 50)) - (60 / 0.6)
	
	move_and_slide()
	
	
	if position.y < 21:
		AreaManager.travel_areas(Vector2i.UP)
		
		AreaManager.player_position.x = self.position.x
		AreaManager.player_position.y = AreaManager.AREA_SIZE.y * 50 - 22
	
	
	if position.x < 21:
		AreaManager.travel_areas(Vector2i.LEFT)
		
		AreaManager.player_position.x = AreaManager.AREA_SIZE.x * 50 - 22
		AreaManager.player_position.y = self.position.y
	
	
	if position.y > AreaManager.AREA_SIZE.y * 50 - 21:
		AreaManager.travel_areas(Vector2i.DOWN)
		
		AreaManager.player_position.x = self.position.x
		AreaManager.player_position.y = 22
	
	
	if position.x > AreaManager.AREA_SIZE.x * 50 - 21:
		AreaManager.travel_areas(Vector2i.RIGHT)
		
		AreaManager.player_position.x = 22
		AreaManager.player_position.y = self.position.y

