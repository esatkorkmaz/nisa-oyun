extends Node

@export var _orca_dialogue_duration: int = 4

var game_manager: Node

var _lives_label: Label
var _coins_label: Label

var _game_lost_node: Node
var _game_win_node: Node
var _orca_dialogue: Array[Node]

func connect_buttons() -> void:
	for node in get_tree().get_nodes_in_group("ui_buttons"):
		match node.name:
			"RetryButton": node.pressed.connect(_on_retry_pressed)
			"PlayButton": node.pressed.connect(_on_play_pressed)
			"QuitButton": node.pressed.connect(_on_quit_pressed)

func connect_labels() -> void:
	for node in get_tree().get_nodes_in_group("ui_labels"):
		match node.name:
			"LivesLabel": _lives_label = node
			"CoinsLabel": _coins_label = node
	
	if game_manager == null:
		return
	
	_lives_label.text = "Lives: %d" % game_manager.lives
	_coins_label.text = "Coins: %d" % game_manager.coins
	
	game_manager.lives_changed.connect(update_lives)
	game_manager.coins_changed.connect(update_coins)

func connect_nodes() -> void:
	for node in get_tree().get_nodes_in_group("ui_nodes"):
		match node.name:
			"GameLostNode": _game_lost_node = node
			"GameWinNode": _game_win_node = node
			"OrcaDialogueContainer": _orca_dialogue = node.get_children()
	
	if game_manager == null:
		return
	
	game_manager.game_lost.connect(show_game_lost_node)
	
func play_orca_dialogues() -> void:
	for dialogue in _orca_dialogue:
		dialogue.visible = true
		await get_tree().create_timer(_orca_dialogue_duration).timeout
		
	show_game_win_node()

func update_lives(value: int) -> void:
	_lives_label.text = "Lives: %d" % value

func update_coins(value: int) -> void:
	_coins_label.text = "Coins: %d" % value

func show_game_lost_node() -> void:
	_game_lost_node.show()
	
func show_game_win_node() -> void:
	_game_win_node.show()

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
