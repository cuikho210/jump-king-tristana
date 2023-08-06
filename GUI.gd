extends CanvasLayer
signal pause_game
signal continue_game

func open_menu():
	$Menu.show()
	pause_game.emit()

func close_menu():
	$Menu.hide()
	continue_game.emit()

func toggle_show_fps(is_enable: bool):
	get_parent().get_node("HUD").toggle_show_fps(is_enable)

func toggle_music(is_enable: bool):
	get_parent().toggle_music(is_enable)

func set_enable_music(is_enable):
	$Menu/MarginContainer/Panel/MusicToggle.button_pressed = is_enable

func set_show_fps(is_enable):
	$Menu/MarginContainer/Panel/ShowFPSToggle.button_pressed = is_enable
