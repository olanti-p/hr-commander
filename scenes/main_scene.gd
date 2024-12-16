extends Node2D
class_name MainScene


var difficulty_score: int = 1

const packed_enemy: PackedScene = preload("res://scenes/enemy_ship.tscn")

var sync_unlocked: bool = false
var magnet_unlocked: bool = false

signal shot_sync()


func add_projectile(proj: Node2D):
	$Projectiles.add_child(proj)


func _add_enemy_internal(ship: Node2D):
	$Enemies.add_child(ship)

func add_enemy(ship: Node2D):
	call_deferred("_add_enemy_internal", ship)

func get_player_pos() -> Vector2:
	return $PlayerShip.global_position

func get_planet_pos() -> Vector2:
	return $Planet/PlanetEnemyTarget.global_position

func add_player_score(val: int):
	$PlayerShip.score += val


func _on_score_ticker_timeout() -> void:
	add_player_score(1)
	difficulty_score += 1


func pick_spawn_pos(cont: Node2D) -> Vector2:
	var count = cont.get_child_count()
	var idx = randi_range(0, count - 1)
	return cont.get_child(idx).global_position


func do_spawn_one_enemy() -> void:
	var enemy = packed_enemy.instantiate()
	enemy.global_position = pick_spawn_pos($EnemySpawnPoints)
	$Enemies.add_child(enemy)


func _on_enemy_spawn_timer_timeout() -> void:
	var tm = lerpf(2.0, 0.5, difficulty_score * 1.0 / 240.0)
	$EnemySpawnTimer.start(tm)
	
	do_spawn_one_enemy()
	if difficulty_score > 40 and randi_range(1, 3) == 1:
		do_spawn_one_enemy()
	if difficulty_score > 80 and randi_range(1, 3) == 1:
		do_spawn_one_enemy()
	if difficulty_score > 140 and randi_range(1, 3) == 1:
		do_spawn_one_enemy()
	if difficulty_score > 200 and randi_range(1, 3) == 1:
		do_spawn_one_enemy()
	
func play_enemy_shoot():
	$EnemyShoot.play()

func play_enemy_death():
	$EnemyDeath.play()


func _process(delta: float) -> void:
	%Skybox.motion_offset.x += delta * 2


func _on_planet_enemy_entered() -> void:
	$PlayerShip.hp = 0


func _on_synced_shot_timeout() -> void:
	shot_sync.emit()
