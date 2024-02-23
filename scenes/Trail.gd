extends Sprite

func _ready():
	$Tween.interpolate_property(self, 'modulate', Color(1,1,1,1), Color(1,1,1,1), 0.2, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()

