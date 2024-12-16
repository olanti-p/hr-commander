extends Area2D

@export var hp_per_hit: int = 10
@export var hp_per_pod: int = 20

@export var speed: float = 400.0

const POS_LIMIT: float = 24.0

const bullet_packed: PackedScene = preload("res://scenes/bullet.tscn")

var is_reloading: bool = false

var dodge_unlocked: bool = false
var armor_unlocked: bool = false
var sync_unlocked: bool = false
var magnet_unlocked: bool = false

@export var pod_score_value: int = 10

var hp: int = 100:
	set(value):
		hp = clampi(value, 0, 100)
		$PlayerUI.hp = hp
		if hp == 0:
			get_tree().paused = true
var score: int = 0:
	set(value):
		score = max(value, 0)
		$PlayerUI.score = score


func on_hit():
	if armor_unlocked:
		hp -= (hp_per_hit / 2)
	else:
		hp -= hp_per_hit
	$Damaged.play()


func _on_area_entered(area: Area2D) -> void:
	if area is EscapePod:
		area.queue_free()
		hp += hp_per_pod
		score += pod_score_value
		$PickedUpPod.play()


func _ready() -> void:
	hp = 100
	score = 0


func _process(delta: float) -> void:
	get_parent().sync_unlocked = sync_unlocked
	get_parent().magnet_unlocked = magnet_unlocked
	
	$Rotatable.look_at(get_global_mouse_position())
	
	var dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	position += dir * speed * delta
	
	if dodge_unlocked and Input.is_action_just_pressed("blink"):
		position += 200 * dir
	
	position.x = clamp(position.x, 0 + POS_LIMIT, 1280 - POS_LIMIT)
	position.y = clamp(position.y, 0 + POS_LIMIT, 720 - POS_LIMIT)
	
	if !is_reloading && Input.is_action_pressed("fire"):
		is_reloading = true
		$ReloadTimer.start()
		var bullet_r = bullet_packed.instantiate()
		bullet_r.global_position = %GunR.global_position
		bullet_r.global_rotation = $Rotatable.global_rotation
		bullet_r.global_rotation_degrees += 90
		bullet_r.is_player_bullet = true
		var bullet_l = bullet_packed.instantiate()
		bullet_l.global_position = %GunL.global_position
		bullet_l.global_rotation = $Rotatable.global_rotation
		bullet_l.global_rotation_degrees += 90
		bullet_l.is_player_bullet = true
		get_parent().add_projectile(bullet_r)
		get_parent().add_projectile(bullet_l)
		$Fire.play()


func _on_reload_timer_timeout() -> void:
	is_reloading = false
