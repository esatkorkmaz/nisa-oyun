extends Area2D

func _on_body_entered(body: CharacterBody2D) -> void:
	body.enter_ladder()

func _on_body_exited(body: CharacterBody2D) -> void:
	body.exit_ladder()
