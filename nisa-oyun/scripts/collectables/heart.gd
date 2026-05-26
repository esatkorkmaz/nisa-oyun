extends Area2D

func _on_body_entered(body: CharacterBody2D) -> void:
	if %GameManager.add_life(): queue_free()
