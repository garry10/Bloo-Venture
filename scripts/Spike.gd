extends Area2D

func _on_Spike_body_entered(body):
	if body.name == "Bloo":
		PlayerData.died(PlayerData.current_stage_path)
