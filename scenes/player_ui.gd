extends CanvasLayer

var hp: int = 100:
	set(value):
		hp = clampi(value, 0, 100)
		%HpBar.value = value
		if hp == 0:
			$GameOver.visible = true
			$GameOverSound.play()
			%ScoreFinal.text = "%d" % score

var score: int = 0:
	set(value):
		score = max(value, 0)
		%ScoreText.text = "Score: %d" % score

func _ready() -> void:
	$GameOver.visible = false
	$UpgradeUI.visible = false


func _process(delta: float) -> void:
	if $UpgradeUI.visible:
		if !get_parent().magnet_unlocked && Input.is_action_just_pressed("upgrade_pod_magnet"):
			get_parent().magnet_unlocked = true
			$UpgradeUI.visible = false
		if !get_parent().armor_unlocked && Input.is_action_just_pressed("upgrade_armor"):
			get_parent().armor_unlocked = true
			$UpgradeUI.visible = false
		if !get_parent().sync_unlocked && Input.is_action_just_pressed("upgrade_enemy_sync"):
			get_parent().sync_unlocked = true
			$UpgradeUI.visible = false
		if !get_parent().dodge_unlocked && Input.is_action_just_pressed("upgrade_blink"):
			get_parent().dodge_unlocked = true
			$UpgradeUI.visible = false


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_upgrade_timer_timeout() -> void:
	if !get_parent().magnet_unlocked || \
	  !get_parent().armor_unlocked || \
	  !get_parent().sync_unlocked || \
	  !get_parent().dodge_unlocked:
		$UpgradeUI.visible = true
