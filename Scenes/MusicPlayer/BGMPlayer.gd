extends AudioStreamPlayer

func _ready():
	self.stream = load("res://Resources/Sound/BGM/Dramatic Swarm - Doug Maxwell.wav")
	self.play()
	
var song_index := 0
func change_song(new_song_index: int):
	song_index = new_song_index
	$Tween.interpolate_property(self, "volume_db", -12, -80, 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.interpolate_property(self, "volume_db", -80, -12, 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 4)
	
	$Timer.start()
	$Tween.start()

func _on_Timer_timeout():
	match(song_index):
		0:
			self.stream = load("res://Resources/Sound/BGM/Dramatic Swarm - Doug Maxwell.wav")
		1:
			self.stream = load("res://Resources/Sound/BGM/Intrigue - Max Surla_Media Right Productions.wav")
		2:
			self.stream = load("res://Resources/Sound/BGM/Smart Riot - Huma-Huma.wav")
	self.play()
