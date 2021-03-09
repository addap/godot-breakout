extends KinematicBody2D

export (float, 300.0, 500.0, 5) var speed = 200.0
export var direction = Vector2(0, -1)
export var impact = 5

signal game_over

var start = false


# func _physics_process(delta):
# 	var first = true
# 	var max_iter = 3
# 	var collision = null
# 	var restspeed = speed

# 	# bewegen uns hoechstens 2 mal in einem physics step (physics auf 60fps) 
# 	# der for loop sollte immer nur zwei mal durchlaufen werden
# 	# einmal an anfang und falls es kollidiert, nochmal mit dem remainder
# 	# eine zweite Kollision ist unwahrscheinlich, wenn der Ball nicht gerade super nah
# 	# an zwei bodies ist.
# 	for n in max_iter:
# 		if !(first || collision != null):
# 			break

# 		first = false
# 		assert(direction.is_normalized(), "should be normal")

# 		collision = move_and_collide(direction * restspeed)
#       ...

func jitter(v: Vector2, r: float = PI/8) -> Vector2:
	return v.rotated(rand_range(-r, r))

func _process(_delta):
	if !start && Input.is_action_pressed("ui_start"):
		start = true
		direction = jitter(direction, PI/4)

func _physics_process(delta):
	if !start:
		return

	var start_position = position
	var collision : KinematicCollision2D = move_and_collide(direction * speed * delta)
	var end_position = position

	var _first_len = (end_position - start_position).length()

	if collision != null:
		print("hit!")
		# print(collision.remainder)
		var normal = collision.normal.normalized()
		
		# project velocity on normal to check how much velocity should impact ball
		# var impact_direction = collision.collider_velocity.dot(normal)
		# print(impact_direction)		

		# https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
		
		# direction - 2 * direction.dot(normal) * normal
		var reflected_direction = direction.bounce(normal)

		# if collision.collider_velocity.x != 0:
		# 	reflected_direction = (reflected_direction + impact * normal) / 2

		# kill the brick
		if collision.collider.is_in_group('bricks'):
			collision.collider.damage()
			reflected_direction = jitter(reflected_direction)

		direction = reflected_direction.normalized()

		# man koennte auch einfacher hier eine zweite Bewegung starten, jeder weitere Rest wird dann verworfen.
		# var rem_length = collision.remainder.length()
		# if (rem_length > 0):
		# 	move_and_collide(direction * rem_length)
			

		
	var real_end = position
	var _second_len = (real_end - end_position).length()
	# print(first_len + second_len)
	


func _on_screen_exited():
	emit_signal("game_over");
