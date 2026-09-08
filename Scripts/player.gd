extends CharacterBody2D
@onready var goat_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction=Input.get_vector("left", "right", "up", "down")
	velocity=direction*800
	move_and_slide()
	
	if velocity.length()>0.0: 
		goat_2d.play("walk_animation")
	else:
		goat_2d.play("idle_animation")
