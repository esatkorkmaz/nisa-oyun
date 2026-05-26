extends Area2D

@export var _teleport_node: Node2D

func _on_body_entered(body: CharacterBody2D) -> void:
	body.hit(false)
	body.velocity = Vector2.ZERO
	body.global_position = _teleport_node.global_position
