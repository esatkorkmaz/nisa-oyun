extends Node

@export var _game_lost_node: Control
@export var _game_win_node: Control

@export var _lives_label: Label
@export var _coins_label: Label

func _update_lives_label(new_value: int) -> void:
	_lives_label.text = "Lives: %d" % new_value

func _update_coins_label(new_value: int) -> void:
	_coins_label.text = "Coins: %d" % new_value

func _ready() -> void:
	_update_lives_label(game_manager.lives)
	_update_coins_label(game_manager.coins)
	
	game_manager.lives_changed.connect(_update_lives_label)
	game_manager.coins_changed.connect(_update_coins_label)
	
	game_manager.game_lost.connect(_show_game_lost_node)


func _on_retry_button_pressed() -> void:
	game_manager.reset_lives()
	game_manager.reset_coins()
	
	get_tree().reload_current_scene()
	
func _show_game_lost_node() -> void:
	_game_lost_node.show()
