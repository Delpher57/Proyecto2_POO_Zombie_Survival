extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var turno = 1
export var max_turnos = 2

# Called when the node enters the scene tree for the first time.


# ----------------------------------------------------------


const enemies = [
	preload("res://scenes/entidades/zombies/EnemyA/EnemigoA.tscn"),
]

#coordenadas de los puntos de generacion
var zonas = [
	Vector2(848,400),
	Vector2(752,912)
]

func _ready():
	spawn()
	pass

func choose(choises):
	randomize()
	var rand_index = randi() % choises.size()
	return choises[rand_index]
	pass
	
	
func spawn():
	randomize()
	
	var enemy = choose(enemies).instance()
	enemy.position = choose(zonas)
	add_child(enemy)
	print ("enemigo generado: " , enemy.name)
	pass



func create_timer(wait_time):
	var timer = Timer.new()
	timer.set_wait_time(wait_time)
	timer.set_one_shot(true)
	timer.connect("timeout", timer, "queue_free")
	add_child(timer)
	timer.start()
	return timer
	pass


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		
		var global_mouse_pos = get_global_mouse_position()
		if turno == 1:
			get_node("Craigh")._pasos = get_node("Craigh")._rango
			get_node("Craigh")._target_position = global_mouse_pos
			get_node("Craigh")._change_state(get_node("Craigh").Estado.FOLLOW)
			get_node("Craigh/Camera2D").current = true
			turno = 2
			yield(create_timer(3), "timeout")
			get_node("Firebot/Camera2D").current = true
			return
		
		if turno == 2:
			get_node("Firebot")._pasos = get_node("Firebot")._rango
			get_node("Firebot")._target_position = global_mouse_pos
			get_node("Firebot")._change_state(get_node("Firebot").Estado.FOLLOW)
			get_node("Firebot/Camera2D").current = true
			
			yield(create_timer(3), "timeout")
			get_node("generalcam").current = true
			yield(create_timer(3), "timeout")
			get_node("Craigh/Camera2D").current = true
			
			spawn()
			turno = 1
			return
			


		
		
		
