extends Node

func _ready() -> void:
	ui_manager.game_manager = %GameManager
	
	ui_manager.connect_buttons()
	ui_manager.connect_labels()
	ui_manager.connect_nodes()
