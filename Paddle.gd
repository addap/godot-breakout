extends KinematicBody2D

export var speed = 10

func _ready():
	$AnimatedSprite.play()

func _physics_process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1

	move_and_collide(velocity * speed)