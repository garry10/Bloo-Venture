extends Area2D

var key_sprite = preload("res://items/key.tscn")

func _on_Key_body_entered(body):
	if body.name == "Bloo" && $"coin-outline".visible == true:
		$"coin-outline".visible = false
		PlayerData.add_coins()
		$collect.play()
		yield($collect, "finished")
		self.queue_free()
		pass
