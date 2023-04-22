extends Area2D

var player = null

func player_detected():
	return player != null

func _on_body_entered(body):
	player = body

func _on_body_exited(body):
	player = null
