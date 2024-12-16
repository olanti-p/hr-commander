extends Area2D
class_name EnemyShip

var is_reloading: bool = false
var should_fire_right: bool = true

const bullet_packed: PackedScene = preload("res://scenes/bullet.tscn")
const pod_packed: PackedScene = preload("res://scenes/escape_pod.tscn")

@export var speed: float = 30.0
@export var hp: int = 40
@export var score_value: int = 5


func get_forward_vector() -> Vector2:
	return (%Forward.global_position - global_position).normalized()

func get_planet_vector() -> Vector2:
	return (get_level().get_planet_pos() - global_position).normalized()


func get_level() -> MainScene:
	return get_parent().get_parent()


var is_dead: bool = false

func on_hit():
	hp -= 10
	if hp <= 0 && !is_dead:
		is_dead = true
		queue_free()
		get_level().play_enemy_death()
		get_level().add_player_score(score_value)
		if randi_range(1, 2) == 1:
			var escape_pod: EscapePod = pod_packed.instantiate()
			escape_pod.global_position = global_position
			$Rotatable.look_at(get_level().get_planet_pos())
			escape_pod.rotation_degrees = $Rotatable.rotation_degrees - 90 + randf_range(-45, 45)
			if get_level().magnet_unlocked:
				escape_pod.rotation_degrees += 180
			get_level().add_enemy(escape_pod)


func _process(delta: float) -> void:
	$Rotatable.look_at(get_level().get_player_pos())
	
	global_position += get_planet_vector()  * speed * delta
	
	if is_reloading:
		return
	
	var bullet = bullet_packed.instantiate()
	bullet.global_position = %GunR.global_position if should_fire_right else %GunL.global_position
	bullet.global_rotation = $Rotatable.global_rotation
	bullet.global_rotation_degrees += 90
	bullet.is_player_bullet = false
	get_level().add_projectile(bullet)
	should_fire_right = !should_fire_right
	$ReloadTimer.start()
	get_level().play_enemy_shoot()
	is_reloading = true


func _ready() -> void:
	get_level().shot_sync.connect(_on_sync_shot)


func _on_sync_shot() -> void:
	if !get_level().sync_unlocked:
		return
	is_reloading = false

func _on_reload_timer_timeout() -> void:
	if get_level().sync_unlocked:
		return
	is_reloading = false
