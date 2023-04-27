extends Node2D

@onready var GrassEffect = preload("res://Effects/grass_effect.tscn")

func grass_effect():
	var grassEffect = GrassEffect.instantiate()
	get_parent().add_child(grassEffect)
	grassEffect.position = position
	
func _on_hurtbox_area_entered(area):
	grass_effect()
	queue_free()
