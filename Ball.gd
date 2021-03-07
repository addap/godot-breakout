extends KinematicBody2D

export (float, 1.0, 5.0, 0.2) var speed = 3.0
export var direction = Vector2(0, -1)

signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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

# 		if collision != null:
# 			if n == 2:
# 				print("two hits!")

# 			print("hit!")
# 			# kollision stoppt die bewegung. In remainder ist die noch verbleibende Distanz
# 			print(collision.remainder)

# 			# https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector			
# 			var normal = collision.normal.normalized()
# 			var reflected_direction = direction - 2 * direction.dot(normal) * normal

# 			direction = reflected_direction
# 			restspeed = collision.remainder.length()

# func _draw():
# 	if p1 && p2:
# 		draw_line(p1, p2, Color(1, 0, 0))

func _physics_process(delta):
	var start_position = position
	var collision = move_and_collide(direction * speed)
	var end_position = position

	var first_len = (end_position - start_position).length()

	if collision != null:
		print("hit!")
		print(collision.remainder)
		
		# kill the brick
		collision.collider.queue_free()

		# https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
		var normal = collision.normal.normalized()
		var reflected_direction = direction - 2 * direction.dot(normal) * normal
		reflected_direction = reflected_direction.rotated(rand_range(-PI/8, PI/8))

		# emit_signal("hit", collision.position, collision.position + 100 * normal)

		direction = reflected_direction

		# man koennte auch einfacher hier eine zweite Bewegung starten, jeder weitere Rest wird dann verworfen.
		var rem_length = collision.remainder.length()
		if (rem_length > 0):
			move_and_collide(direction * rem_length)
			

		
	var real_end = position
	var second_len = (real_end - end_position).length()
	# print(first_len + second_len)
	


func _on_screen_exited():
	emit_signal("game_over");
