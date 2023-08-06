extends CanvasLayer
signal new_game

var score = 0
var is_show_fps = false

func _ready():
	var screen_width = get_viewport().get_visible_rect().size.x
	$DownTouchButton.position.x = screen_width - 640

func _on_play_button_pressed():
	new_game.emit()

func _on_score_timer_timeout():
	score += 1
	$HBoxContainer/ScoreLabel.text = "Score: " + str(score)

func _process(_delta):
	if is_show_fps:
		var fps = Engine.get_frames_per_second()
		$HBoxContainer/FPSLabel.text = str(fps) + " FPS"

func toggle_show_fps(is_enable: bool):
	$HBoxContainer/FPSLabel.text = ""
	is_show_fps = is_enable

func update_best_score(best_score):
	$HBoxContainer/BestScoreLabel.text = "Best score: " + str(best_score)