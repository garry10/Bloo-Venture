extends Node2D

func _ready():
	PlayerData.inGame = false
	PlayerData.MainMenu = true


func _on_Button_pressed():
	SceneTransition.change_scene("res://mapSelect.tscn")

func _on_settingBtn_pressed():
	SceneTransition.change_scene("res://mapSelect.tscn")
