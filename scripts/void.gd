extends Area2D

func _on_void_body_entered(_body):
	PlayerData.died(PlayerData.current_stage_path)
