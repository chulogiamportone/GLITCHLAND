extends Node

# Ajustá las rutas a tus escenas reales
@onready var trap_scene = preload("res://Scenes/hammer.tscn")  # o la escena donde está el script con _physics_process
@onready var player_scene = preload("res://Scenes/character_body_2d.tscn")

func _ready() -> void:
	print("== INICIO DE TESTS ==")

	await run_test_increase_life_on_trap()
	await run_test_reposition_on_trap()

	print("== FIN DE TESTS ==")
	get_tree().quit()


# 🔹 TEST 1: Verifica que la vida aumente al ser atrapado por la trampa
func run_test_increase_life_on_trap() -> void:
	print("➡️ Test: Incremento de vida con trampa activa")

	var trap = trap_scene.instantiate()
	var player = player_scene.instantiate()

	add_child(trap)
	add_child(player)

	# Simulamos que el cuerpo entra al área
	trap._on_area_2d_2_body_entered(player)

	# Configuramos los valores que activarían la trampa
	trap.is_body_inside = true
	trap.body_inside = player
	trap.frame = 2  # valor que hace que trap_hurt sea true

	var initial_life = player.life

	# Ejecutamos varios frames de _physics_process para simular tiempo real
	for i in range(5):
		trap._physics_process(0.016)
		await get_tree().process_frame

	var expected = initial_life + 1
	if player.life == expected:
		print("✅ PASSED: Vida = %d" % player.life)
	else:
		printerr("❌ FAILED: Esperado %d, obtenido %d" % [expected, player.life])

	player.queue_free()
	trap.queue_free()


# 🔹 TEST 2: Verifica que el personaje se reposicione tras morir por la trampa
func run_test_reposition_on_trap() -> void:
	print("➡️ Test: Reposición del jugador tras trampa")

	var trap = trap_scene.instantiate()
	var player = player_scene.instantiate()

	add_child(trap)
	add_child(player)

	# Simulamos entrada al área
	trap._on_area_2d_2_body_entered(player)

	# Activamos la trampa
	trap.is_body_inside = true
	trap.body_inside = player
	trap.frame = 1

	# Ejecutamos varios frames para permitir que se procese la lógica
	for i in range(5):
		trap._physics_process(0.016)
		await get_tree().process_frame

	var expected_position = Vector2(1142.0, 515.0)
	if player.position == expected_position:
		print("✅ PASSED: Posición correcta %s" % str(player.position))
	else:
		printerr("❌ FAILED: Esperado %s, obtenido %s" % [str(expected_position), str(player.position)])

	player.queue_free()
	trap.queue_free()
