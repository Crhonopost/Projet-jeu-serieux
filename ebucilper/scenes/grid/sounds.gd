extends AudioStreamPlayer

var waiting_blocks = 0

func place_block():
	if(waiting_blocks == 0):
		$PlaceBlockTimer.start()
	waiting_blocks += 1

func _on_place_block_timer_timeout() -> void:
	if(waiting_blocks > 0):
		play()
		waiting_blocks -= 1
	else:
		$PlaceBlockTimer.stop()
