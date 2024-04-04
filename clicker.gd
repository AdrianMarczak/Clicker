extends Node
var save_path = "user://safefile.save"

var score = 0
var clickgain = 1
var clicklevel = 1
var bonusclick = 0

var autogain = 0
var autolevel = 0
var bonusauto = 0


func _ready():
	load_game()
	autowait()
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_EXIT_TREE or what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_CRASH or what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_GO_BACK_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		save_game()
		print("saved")

func _process(delta):
	$Score.text = str(score) + "$"
	clickgain = clicklevel + bonusclick
	autogain = autolevel + bonusauto


func autowait():
	await get_tree().create_timer(1).timeout
	score += autogain
	autowait()

func _on_button_pressed():
	score += clickgain



func _on_upgradeclick_pressed():
	if score >= clicklevel * 10:
		score -= clicklevel * 10
		clicklevel += 1
		


func _on_upgradeauto_pressed():
	if score >= autolevel * 10:
		score -= autolevel * 10
		autolevel += 1

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(score)
	file.store_var(clicklevel)
	file.store_var(autolevel)

func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		score = file.get_var(score)
		clicklevel = file.get_var(clicklevel)
		autolevel = file.get_var(autolevel)
		print("loaded")
	else:
		print("no save data saved...")
		score = 0
		clicklevel = 1
		autolevel = 0
