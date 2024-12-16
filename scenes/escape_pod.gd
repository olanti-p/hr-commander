extends Area2D
class_name EscapePod

@export var speed: float = 10.0

func get_forward_vector() -> Vector2:
	return ($Forward.global_position - global_position).normalized()

func _process(delta: float) -> void:
	global_position += get_forward_vector() * speed * delta

func _on_area_entered(_area: Area2D) -> void:
	# Escaped!
	queue_free()
