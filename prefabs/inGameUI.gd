extends CanvasLayer

var time = 0
onready var levelLabel = $Control/levelLabel
onready var coinCounter = $Control/levelLabel/coinCounter
var hideUI = false

func _process(delta):
	if PlayerData.MainMenu == true or hideUI == true:
		$Control.hide()
	else:
		$Control.show()
	if Input.is_action_just_pressed("hideUI") && PlayerData.MainMenu == false:
		hideUI = !hideUI
	if PlayerData.inGame && !get_tree().paused:
		time += delta
	
	var mils = fmod(time, 1)*100
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "%02d : %02d : %02d" % [mins,secs,mils]
	$Control/timerLabel.text = time_passed

func resetTime():
	time = 0

func _on_pauseBtn_pressed():
	get_tree().paused = true
	$PauseMenu.show()

func _on_resumeBtn_pressed():
	get_tree().paused = false
	$PauseMenu.hide()

func _on_mainMenuBtn_pressed():
	PlayerData.current_stage = 0
	inGameUI.resetTime()
	PlayerData.MainMenu = true
	SceneTransition.change_scene("res://MainMenu.tscn", 0.1)

func _on_restartBtn_pressed():
	PlayerData.reset_stage()

func _pop_up_winUI():
	pass


