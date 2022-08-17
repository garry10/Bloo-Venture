extends Area2D

var next_level_path : String

func _ready():
	if PlayerData.current_level != PlayerData.max_level:
		next_level_path = "res://levels/Level" + String(PlayerData.current_level + 1) + ".tscn"

func _on_Door_body_entered(body):
	if body.name == "Bloo":
		if PlayerData.is_holding_key == true:
			$collect.play()
			PlayerData.is_holding_key = false
			$key.modulate = Color("ffff96")
			body.get_node("Blue/handle/key").queue_free()
			yield($collect, "finished")
			if PlayerData.current_level != PlayerData.max_level:
				PlayerData.current_level += 1
				var _n = get_tree().change_scene(next_level_path)
			else:
				pass #teleport to credit scene
