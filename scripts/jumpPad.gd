extends Area2D




func _on_jumpPad_body_entered(body):
	body.jump(-140)
	body.start_dash(0.5)
