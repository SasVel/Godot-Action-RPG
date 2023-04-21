extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

func _on_area_entered(area):
	var effect = HitEffect.instantiate()
	var parent = get_parent().get_parent()
	parent.add_child(effect)
	effect.global_position = global_position
