extends CanvasLayer

signal sceneChanged()

var changing_scene = false
onready var anim_plr = $AnimationPlayer

func is_changing_scene():
	return changing_scene

func change_scene(path, delay = 0.5):
	if changing_scene:
		return 
	else:
		changing_scene = true
	$Control.show()
	anim_plr.play("fade")
	yield(anim_plr, "animation_finished")
	yield(get_tree().create_timer(delay), "timeout")
	get_tree().paused = false
	inGameUI.get_node("PauseMenu").hide()
	var _n = get_tree().change_scene(path)
	anim_plr.play_backwards("fade")
	yield(anim_plr, "animation_finished")
	$Control.hide()
	changing_scene = false
	emit_signal("sceneChanged")

func Trans(delay = 0.5):
	$Control.show()
	anim_plr.play("fade")
	yield(anim_plr, "animation_finished")
	yield(get_tree().create_timer(delay), "timeout")
	get_tree().paused = false
	inGameUI.get_node("PauseMenu").hide()
	anim_plr.play_backwards("fade")
	yield(anim_plr, "animation_finished")
	$Control.hide()
	emit_signal("sceneChanged")
