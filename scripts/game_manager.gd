extends Node

func become_host():
	print("become host pressed!")
	%multiplayerHUD.hide()
	MultiplayerManager.become_host()

func join_game():
	print("Join game pressed!")
	%multiplayerHUD.hide()
	MultiplayerManager.join_game()
