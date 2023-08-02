extends Node

@export var Rock: PackedScene
@export var Monster: PackedScene
@export var Girl: PackedScene
var platform_width = 1280
var pre_distance = 0
var is_playing = false

func game_over():
	$HUD.get_node("Message").show()
	$HUD.get_node("PlayButton").show()
	$HUD.get_node("ScoreTimer").stop()
	$HUD.get_node("Message").text = "Game Over!"

	$Player.game_over()
	$BgMusic.stop()
	$GameOverSound.play()
	$MobTimer.stop()

	is_playing = false

func new_game():
	$HUD.get_node("Message").hide()
	$HUD.get_node("PlayButton").hide()
	$HUD.get_node("ScoreTimer").start()
	$HUD.score = 0

	$Player.new_game()
	$BgMusic.play()
	$MobTimer.start()

	is_playing = true
	pre_distance = 0;
	get_tree().call_group("mobs", "queue_free")

func generate_mob():
	if not is_playing: return

	var current_distance = $Player.position.x

	if pre_distance > current_distance:
		pre_distance = current_distance
		return

	if current_distance - pre_distance < 444: return
	pre_distance = current_distance

	# Generate
	var rand = randi_range(0, 4)

	if rand == 1: add_monster()
	elif rand == 2: add_rock()
	elif rand == 3: add_girl()

func add_rock():
	var rock = Rock.instantiate()
	rock.position.x = get_viewport().get_camera_2d().get_screen_center_position().x + platform_width
	rock.position.y = 494
	add_child(rock)

func add_monster():
	var monster = Monster.instantiate()
	monster.position.x = get_viewport().get_camera_2d().get_screen_center_position().x + platform_width
	monster.position.y = randi_range(144, 477)
	add_child(monster)

func add_girl():
	var girl = Girl.instantiate()
	girl.position.x = get_viewport().get_camera_2d().get_screen_center_position().x + platform_width
	girl.position.y = 444
	add_child(girl)


func _on_mob_timer_timeout():
	generate_mob()