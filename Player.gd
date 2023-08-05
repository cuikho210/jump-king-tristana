extends CharacterBody2D

@export var SmokeEffect: PackedScene
var default_speed = 444.0
var jump_velocity = 1777.0
var speed = default_speed
var is_running = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum State { JUMPING, RUNNING }
var pre_state = State.RUNNING

func _ready():
	$Anime.play("idle")

func _physics_process(delta):
	if not is_floor():
		velocity.y += gravity * delta

	if (is_running):
		velocity.x = speed

		# Jump
		if Input.is_action_pressed("up") and is_floor():
			velocity.y = -jump_velocity
			$JumpEffectTimer.start()
			_on_jump_effect_timer_timeout()
		elif Input.is_action_pressed("down"):
			velocity.y = jump_velocity * 2

		move_and_slide()
		position.y = clamp(position.y, 0, 449)

	# Animation
	if !is_floor():
		$Anime.animation = "jump"
		pre_state = State.JUMPING
	elif velocity.x != 0:
		$Anime.animation = "run"

		if pre_state == State.JUMPING:
			add_smoke_effect()
			$JumpEffectTimer.stop()
		pre_state = State.RUNNING
	else:
		$Anime.animation = "idle"

func new_game():
	position.x = 590
	is_running = true
	$SpeedTimer.start()
	$Anime.play("run", 1)

func game_over():
	$SpeedTimer.stop()
	$JumpEffectTimer.stop()
	speed = default_speed
	is_running = false

func is_floor():
	return position.y > 448

func _on_speed_timer_timeout():
	speed += 24
	$Anime.play("run", get_animation_speed())

func add_smoke_effect(animation_name = "drop", x = position.x + 44, y = position.y + 24):
	var effect = SmokeEffect.instantiate()

	effect.position.x = x
	effect.position.y = y
	effect.play(animation_name)

	get_parent().add_child(effect)

func get_animation_speed():
	return speed / default_speed

func _on_jump_effect_timer_timeout():
	add_smoke_effect("jump", position.x - 32, position.y + 32)