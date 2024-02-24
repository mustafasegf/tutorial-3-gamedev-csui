extends Area2D

var explode_scene = preload("res://scenes/Explode.tscn")

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		var player: KinematicBody2D = $"../Player"
		var explode = explode_scene.instance()
		var sprite = player.get_node("Sprite")
		explode.initializer(sprite.texture)
		print(sprite)
		explode.global_position = sprite.global_position
		explode.global_position = sprite.global_position
		explode.rotation_degrees = sprite.rotation_degrees
		explode.scale = sprite.scale * 1.5
		
		var root = $"../../Root"
		root.add_child(explode)
		player.queue_free()
		
		var canvas: CanvasLayer = $"../CanvasLayer"
		canvas.follow_viewport_enable = true
		
		var animation: AnimationPlayer = $"../CanvasLayer/AnimationPlayer"
		
		animation.play("Shockwave")
		
		
