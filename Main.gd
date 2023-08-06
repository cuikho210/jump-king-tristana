extends Node

const SAVE_PATH = "user://data.save"

@export var Corki: PackedScene
@export var CasterMinion: PackedScene
@export var MeleeMinion: PackedScene
var platform_width = 1280
var pre_distance = 0
var is_playing = false
var is_enable_music = false

var save_data = {
	"best_score": 0,
	"is_enable_music": true,
	"is_show_fps": false
}

func _ready():
	load_saved_data()

func game_over():
	$HUD.get_node("Message").show()
	$HUD.get_node("PlayButton").show()
	$HUD.get_node("ScoreTimer").stop()
	$HUD.get_node("Message").text = "Game Over!"
	if $HUD.score > save_data.best_score: $HUD.update_best_score($HUD.score)

	$Player.game_over()
	$MobTimer.stop()

	$BgMusic.stop()
	if is_enable_music: $GameOverSound.play()

	is_playing = false
	save()

func new_game():
	$HUD.get_node("Message").hide()
	$HUD.get_node("PlayButton").hide()
	$HUD.get_node("ScoreTimer").start()
	$HUD.score = 0

	$Player.new_game()
	$MobTimer.start()
	if is_enable_music: $BgMusic.play()

	is_playing = true
	pre_distance = 0;
	get_tree().call_group("mobs", "queue_free")

func pause_game():
	get_tree().paused = true

func continue_game():
	get_tree().paused = false
	save()

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

	if rand == 1: add_corki()
	elif rand == 2: add_melee_minion()
	elif rand == 3: add_caster_minion()

func add_melee_minion():
	var obj = MeleeMinion.instantiate()
	obj.position.x = get_viewport().get_camera_2d().get_screen_center_position().x + platform_width
	obj.position.y = 456
	add_child(obj)

func add_corki():
	var mob = Corki.instantiate()
	mob.position.x = get_viewport().get_camera_2d().get_screen_center_position().x + platform_width
	mob.position.y = randi_range(147, 456)
	add_child(mob)

func add_caster_minion():
	var caster_minion = CasterMinion.instantiate()
	caster_minion.position.x = get_viewport().get_camera_2d().get_screen_center_position().x + platform_width
	caster_minion.position.y = 464
	add_child(caster_minion)

func _on_mob_timer_timeout():
	generate_mob()

func toggle_music(is_enable):
	is_enable_music = is_enable

	if not is_enable: $BgMusic.stop()
	elif is_playing: $BgMusic.play()

func save():
	if save_data.best_score < $HUD.score: save_data.best_score = $HUD.score
	save_data.is_enable_music = is_enable_music
	save_data.is_show_fps = $HUD.is_show_fps

	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	save_file.store_line(json_string)

func load_saved_data():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = save_file.get_line()

	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK: return

	save_data = json.get_data()

	$HUD.update_best_score(save_data.best_score)
	$GUI.set_enable_music(save_data.is_enable_music)
	$GUI.set_show_fps(save_data.is_show_fps)
