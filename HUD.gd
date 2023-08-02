extends CanvasLayer
signal new_game

var score = 0

func _ready():
    var screen_width = get_viewport().get_visible_rect().size.x
    $DownTouchButton.position.x = screen_width - 640

func _on_play_button_pressed():
    new_game.emit()

func _on_score_timer_timeout():
    score += 1
    $ScoreLabel.text = str(score)