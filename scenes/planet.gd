extends Node2D

@export var BaseSpeed: float = 2.0
@export var CloudsSpeed: float = 1.5

signal enemy_entered()

func _ready() -> void:
	$Base.rotation_degrees = randi_range(0, 360)
	$Clouds.rotation_degrees = randi_range(0, 360)

func _process(delta: float) -> void:
	$Base.rotation_degrees += BaseSpeed * delta
	$Clouds.rotation_degrees += CloudsSpeed * delta


func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	enemy_entered.emit()
