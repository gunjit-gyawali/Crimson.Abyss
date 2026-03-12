extends CharacterBody2D

const SPEED = 500
var current_dir = "none"
var is_attacking = false
var attack_duration = 1
var attack_timer = 1

func _physics_process(_delta):
	if is_attacking:
		attack_timer -= _delta
		if attack_timer <= 0:
			is_attacking = false

	if not is_attacking:
		player_movement(_delta)
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func player_movement(_delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	var input_vector = Vector2(x_input, y_input).normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * SPEED
		update_direction(input_vector)
		play_animation(1)
	else:
		velocity = Vector2.ZERO
		play_animation(0)
		
func update_direction(input_vector):
	if abs(input_vector.x) > abs(input_vector.y):
		if input_vector.x > 0:
			current_dir = "right"
		else:
			current_dir = "left"
	else:
		if input_vector.y > 0:
			current_dir = "down"
		else:
			current_dir = "up"

func play_animation(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		else:
			anim.play("side_idel")
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		else:
			anim.play("side_idel")
	elif dir == "down":
		if movement == 1:
			anim.play("front_walk")
		else:
			anim.play("front_idel")
	elif dir == "up":
		if movement == 1:
			anim.play("back_walk")
		else:
			anim.play("back_idel")

func play_attack_animation():
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		anim.play("side_attack")
	elif dir == "left":
		anim.flip_h = true
		anim.play("side_attack")
	elif dir == "down":
		anim.play("front_attack")
	elif dir == "up":
		anim.play("back_attack")

func _input(event):
	if event.is_action_pressed("attack") and not is_attacking:
		is_attacking = true
		attack_timer = attack_duration
		play_attack_animation()
