extends Node2D

export var max_coin = 3

func _ready():
	PlayerData.MainMenu = false
	inGameUI.coinCounter.text = "0/" + String(max_coin)
	inGameUI.levelLabel.text = "Stage " + String(PlayerData.current_stage)
	PlayerData.max_coin = max_coin
	PlayerData.coin = 0


