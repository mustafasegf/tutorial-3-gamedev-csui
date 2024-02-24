extends Particles2D

func _ready():
	emitting = true
	one_shot = true

#var sfx = preload("res://assets/ligma1.mp3")

func initializer(sprite: Texture):
	print("initialze")
	
	process_material.set_shader_param("emmision_box_extents",
		Vector3(sprite.get_width() / 2.0, sprite.get_height() / 2.0, 1)
	)

	process_material.set_shader_param("sprite", sprite)
	amount = sprite.get_width() * sprite.get_height()

	emitting = true
	
	$AudioStreamPlayer2D.stream.loop = false
	$AudioStreamPlayer2D.play()
	
