extends Area2D

@export var _destination_node: Node2D

func _on_body_entered(body: CharacterBody2D) -> void:
	await get_tree().create_timer(0.5).timeout
	
	body.input_enabled = false
	
	if _destination_node != null:
		body.auto_move_target = _destination_node
		
		await _wait_until_arrived(body)
	
	await get_tree().create_timer(2).timeout
	ui_manager.play_orca_dialogues()

func _wait_until_arrived(body: CharacterBody2D) -> void:
	while body.auto_move_target != null:
		await get_tree().process_frame
