extends KinematicBody2D

export (float, 300.0, 500.0, 5) var speed = 300.0
var extra_speed = 0
export var direction = Vector2(0, -1)
export var impact = 5
var even_bounces = 0

const Brick = preload('res://Brick.gd')
const Paddle = preload('res://Paddle.gd')

signal game_over

var start = false

func _ready():
	set_physics_process(false)

func jitter(v: Vector2, r: float = PI/8) -> Vector2:
	return v.rotated(rand_range(-r, r))

func _process(_delta):
	if !is_physics_processing() && Input.is_action_pressed("ui_start"):
		set_physics_process(true)
		direction = jitter(direction, PI/4)

		var pos = global_position
		var main = get_parent().get_parent()
		get_parent().remove_child(self)
		main.add_child(self)
		global_position = pos

		var vn = VisibilityNotifier2D.new()
		vn.connect("screen_exited", self, "_on_screen_exited")
		add_child(vn)

func _physics_process(delta):
	var collision : KinematicCollision2D = move_and_collide(direction * (speed + extra_speed) * delta)

	if extra_speed > 0:
		extra_speed -= 5

	if collision != null:
		print("hit!")
		var normal = collision.normal.normalized()
		
		# https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
		# direction - 2 * direction.dot(normal) * normal
		var reflected_direction = direction.bounce(normal)

		# simulate impact on the ball from the paddel by interpolating reflected_direction towards normal
		var paddle = collision.collider as Paddle
		if paddle && collision.collider_velocity.x != 0:
			reflected_direction = reflected_direction + impact * normal
			# and give extra speed so it can escape the paddel if it moves
			extra_speed = 200

		# kill the brick
		var brick = collision.collider as Brick
		if brick:
			collision.collider.damage()
			reflected_direction = jitter(reflected_direction)
		
		if (collision.collider.is_in_group('walls') 
			&& abs(direction.angle_to(normal)) > 3):
				even_bounces += 1
		else:
			even_bounces = 0

		if even_bounces >= 4:
			reflected_direction = jitter(reflected_direction, PI/3)
			
		

		direction = reflected_direction.normalized()

func _on_screen_exited():
	emit_signal("game_over");
