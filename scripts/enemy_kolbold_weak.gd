extends CharacterBody2D

@export var movement_speed = randf_range(20, 100)
@export var hp = 10.0
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction.normalized() * movement_speed
	move_and_collide(velocity * delta)
	
	if direction.x > 0.1:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
		

func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
