extends Node

signal coins_changed(new_value: int)
signal lives_changed(new_value: int)
signal game_over()

const _MAX_LIVES: int = 5
const _MIN_LIVES: int = 0
const _MIN_COINS: int = 0

var _coins: int = 0
var _lives: int = 3

var coins: int:
	get:
		return _coins
	set(value):
		_coins = max(_MIN_COINS, value)
		coins_changed.emit(_coins)

var lives: int:
	get:
		return _lives
	set(value):
		var old_lives = _lives
		_lives = clamp(value, _MIN_LIVES, _MAX_LIVES)
		lives_changed.emit(_lives)
		if _lives <= 0 and old_lives > 0:
			game_over.emit()

func add_coins(amount: int) -> void:
	if amount <= 0:
		return
	coins += amount

func spend_coins(amount: int) -> bool:
	if amount <= 0 or _coins < amount:
		return false
	coins -= amount
	return true

func add_life() -> void:
	lives += 1

func lose_life() -> void:
	lives -= 1

func reset_lives(amount: int = 3) -> void:
	lives = amount
