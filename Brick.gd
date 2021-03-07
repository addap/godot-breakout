extends StaticBody2D

func _ready():
	var colors = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = colors[randi() % colors.size()]

func damage():
	if $AnimatedSprite.frame == 0:
		$AnimatedSprite.frame += 1
	else:
		queue_free()
