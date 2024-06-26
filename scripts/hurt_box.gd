extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0
@onready var collision_shape_2d = $CollisionShape2D
@onready var disable_timer = $DisableTimer

signal hurt(damage)

func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: #cooldown
					collision_shape_2d.set_deferred("disabled", true)
					disable_timer.start()
				1: #Hit Once
					pass
				2: #DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt", damage)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)


func _on_disable_timer_timeout():
	collision_shape_2d.set_deferred("disabled", false)
