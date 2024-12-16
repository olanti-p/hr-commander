extends Area2D
class_name Bullet

@export var speed_player: float = 500.0
@export var speed_enemy: float = 200.0

var is_player_bullet: bool = false:
	set(value):
		is_player_bullet = value
		$SpriteEnemy.visible = !is_player_bullet
		$SpritePlayer.visible = is_player_bullet
		set_collision_mask_value(2, !is_player_bullet)
		set_collision_mask_value(3, is_player_bullet)

func get_forward_vector() -> Vector2:
	return ($Forward.global_position - global_position).normalized()

func _process(delta: float) -> void:
	var speed = speed_player if is_player_bullet else speed_enemy
	global_position += get_forward_vector() * speed * delta

func _on_despawn_timer_timeout() -> void:
	queue_free()

var is_dead: bool = false

func _on_area_entered(area: Area2D) -> void:
	if is_dead:
		return
	is_dead = true
	area.on_hit()
	queue_free()
