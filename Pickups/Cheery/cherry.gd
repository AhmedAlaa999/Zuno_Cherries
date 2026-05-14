extends Area2D

@onready var cherry_sound = $"../CherrySound"


func spawn_feedback():
	var scene_to_spawn = preload("res://Pickups/Feedback/feedback.tscn")
	var new_scene_instance = scene_to_spawn.instantiate()

	get_tree().current_scene.add_child(new_scene_instance)
	new_scene_instance.global_position = global_position


func _on_body_entered(body):

	if body.has_method("add_point"):
		body.add_point()

	cherry_sound.play()
	spawn_feedback()
	hide()
	await cherry_sound.finished
	queue_free()
