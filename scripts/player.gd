extends CharacterBody2D


const speed = 100.0
var hp = 10.0
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * speed
	
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h =false
		
	if direction != Vector2.ZERO:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
	move_and_slide()


func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)
