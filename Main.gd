extends Node

export (PackedScene) var Brick
export (PackedScene) var Ball
export (PackedScene) var Paddle

# const BallT = preload("res://Ball.gd")
# var ball: BallT
var ball

const PaddleT = preload("res://Paddle.gd")
var paddle: PaddleT

export var lives = 3

# 5 * 70 + 6 * (15 + 6.6) = 480

var brick_width = 70
var padding = 21.6
var brick_height = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()
	
func new_game():
	get_tree().call_group("bricks", "queue_free")
	for y in range(1, 6):
		for x in range(1, 6):
			var brick = Brick.instance()
			add_child(brick)
			brick.position.y = y * (brick_height + padding) - brick_height / 2 
			brick.position.x = x * (brick_width + padding) - brick_width / 2

	if paddle:
		paddle.queue_free()
	paddle = Paddle.instance()
	add_child(paddle)
	paddle.position = $PaddlePosition.position
	
	if ball:
		ball.queue_free()
	ball = Ball.instance()
	add_child(ball)
	ball.connect("game_over", self, "_on_game_over")
	ball.position = $BallPosition.position


func _on_game_over():
	lives -= 1
	if lives > 0:
		new_game()
	else:
		get_tree().quit()
