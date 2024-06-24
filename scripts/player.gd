extends CharacterBody2D


const speed = 100.0
var hp = 10.0

#Attack
var ice_spear = preload("res://Scenes/ice_spear.tscn")

#AttackNodes
@onready var ice_spear_timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer = $Attack/IceSpearTimer/IceSpearAttackTimer

#IceSpear
var ice_spear_ammo = 0
var ice_spear_base_ammo = 1
var ice_spear_attack_speed = 1.5
var ice_spear_level = 1

#Enemy 
var enemy_close = []

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	attack()
	
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

func attack():
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attack_speed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()
			
func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)

func _on_ice_spear_timer_timeout():
	ice_spear_ammo += ice_spear_base_ammo
	ice_spear_attack_timer.start()

func _on_ice_spear_attack_timer_timeout():
	if ice_spear_ammo > 0:
		var ice_spear_attack = ice_spear.instantiate()
		ice_spear_attack.position = position
		ice_spear_attack.target = get_random_target()
		ice_spear_attack.level = ice_spear_level
		add_child(ice_spear_attack)
		ice_spear_ammo -=1
		if ice_spear_ammo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		enemy_close.sort_custom(sort_closest)
		return enemy_close[0].global_position
	else:
		return Vector2.UP

func sort_closest(a, b):
	return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
