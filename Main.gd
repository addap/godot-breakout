extends Node

export (PackedScene) var Brick

# 5 * 70 + 6 * (15 + 6.6) = 480

var brick_width = 70
var padding = 21.6
var brick_height = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(1, 6):
		for x in range(1, 6):
			var brick = Brick.instance()
			add_child(brick)
			brick.position.y = y * (brick_height + padding) - brick_height / 2 
			brick.position.x = x * (brick_width + padding) - brick_width / 2


func _on_game_over():
	get_tree().quit()
