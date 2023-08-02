extends AnimatedSprite2D

func _ready():
    var anim_types = sprite_frames.get_animation_names()
    play(anim_types[randi() % anim_types.size()])