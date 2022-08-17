extends Area2D

var color_list = {
	"water" : "6ae9ff",
	"fire" : "ff1e1e"
}
export(String, "water", "fire") var element
var pickable = true

func _ready():
	$"coin-outline".modulate = Color(color_list[element])

func change_color(requested_color = "fire"):
	$"coin-outline".modulate = Color(color_list[requested_color])

func _on_Coin_body_entered(body):
	if body.name == "Bloo" && pickable == true:
		pickable = false
		PlayerData.add_coins(1)
		$AnimationPlayer.play("pickedUp")
		$collect.play()
		yield(get_tree().create_timer(0.5), "timeout")
		self.queue_free()
		pass
