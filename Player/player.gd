extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var points_label = $"../UI/Panel/Points Label"
@onready var timer_label = $"../UI/Panel/TimerLabel1"
@onready var result_label = $"../UI/Panel/ResultLabel"

@onready var win_sound = $"../WinSound"
@onready var lose_sound = $"../LoseSound"
@onready var jump_sound = $"../JumpSound"

var points = 0
var time_left = 60
var game_over = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	if game_over:
		return

	time_left -= delta
	timer_label.text = "Timer : " + str(int(time_left))

	if time_left <= 0 and not game_over:
		game_over = true
		lose()

	
	if not is_on_floor():
		velocity.y += gravity * delta

	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	
	var input_axis = Input.get_axis("ui_left", "ui_right")

	if input_axis:
		velocity.x = input_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animations(input_axis)


func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

	if not is_on_floor():
		animated_sprite_2d.play("jump")


func add_point():
	points += 1
	points_label.text = "Points : " + str(points)

	if points >= 8 and not game_over:
		game_over = true
		win()


func win():

	result_label.text = "YOU WIN"

	win_sound.play()

	await get_tree().create_timer(4.0).timeout

	get_tree().reload_current_scene()


func lose():

	result_label.text = "YOU LOSE"

	lose_sound.play()

	await get_tree().create_timer(4.0).timeout

	get_tree().reload_current_scene()
