extends CharacterBody2D
@onready var goat_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction=Input.get_vector("left", "right", "up", "down")
	var h_direction := Input.get_axis("left", "right")
	velocity=direction*300
	move_and_slide()
	
	if velocity.length()>0.0: 
		goat_2d.play("walk_animation")
		if h_direction < 0:
			goat_2d.flip_h = true
		else: 
			goat_2d.flip_h = false
	else:
		goat_2d.play("idle_animation")
