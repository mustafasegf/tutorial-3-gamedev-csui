extends Area2D

func _on_WinArea_body_entered(body: Node) -> void:
	if body is KinematicBody2D:
		
		$AudioStreamPlayer2D.stream.loop = false
		$AudioStreamPlayer2D.play()

