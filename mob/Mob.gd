extends Area2D

func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()

func _on_body_entered(_body:Node2D):
    get_parent().game_over()