extends Node
var game_running = false
signal reset
signal game_over

func start_game():
	reset.emit()
	$Button.hide()
	$Label.hide()
	game_running = true
	
func end_game():
		$Button.show()
		$Label.show()
		game_running = false
		game_over.emit()

func _on_test_sheep_dead(_filler):
	if game_running:
		end_game()
		$Label.set_text("Player 2 wins!")

func _on_test_sheep_2_dead(_filler):
	if game_running:
		end_game()
		$Label.set_text("Player 1 wins!")

func _on_button_pressed():
	start_game()
