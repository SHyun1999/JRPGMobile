extends Node

var turn_order = []
var turn_count := 1

func _ready() -> void:
	combat()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		CombatObserver.player_action_taken.emit()
	if Input.is_action_just_pressed("ui_right"):
		CombatObserver.enemy_action_taken.emit()


func set_turn_order() -> void:
	if len(turn_order) < 1:
		#sort entities by their speed ascending
		turn_order = get_tree().get_nodes_in_group("entity")
		turn_order.sort_custom(
			func(a, b): return a.stats.speed < b.stats.speed
		)


func combat() -> void:
	turn_count = 0
	for i in 10:
		turn_count += 1
		print("turn: ", turn_count)
		set_turn_order()
		var entity_turn = turn_order.pop_back()
		
		while entity_turn:
			if entity_turn.is_in_group("player"):
				print("awaiting player move...")
				await(CombatObserver.player_action_taken)
			elif entity_turn.is_in_group("enemy"):
				print("awaiting enemy move...")
				await(CombatObserver.enemy_action_taken)
			entity_turn = turn_order.pop_back()
	print("end of combat!")

