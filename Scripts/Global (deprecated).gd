extends Node2D

var tam_traco = 0
var max_tam_traco = 9
var tracos = []
# modo 0 para adicionar, modo 1 para editar
var modo = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(qtde_traco)
	update()

func _draw():
	if tracos.size() >= 2:
		for i in (tracos.size() - 1):
			draw_line(Vector2(tracos[i][0], tracos[i][1]),
					Vector2(tracos[i+1][0], tracos[i+1][1]),
					Color(0, 255, 0), 10, true)

# Gerenciar inputs
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Clique em: ", event.position)
			if modo == 0:
				tracos.append(event.position)
				calcula_tamanho_traco()
		else:
			print("Desclique em :", event.position)


func _on_ButtonCriar_pressed():
	modo = 0

func _on_ButtonMover_pressed():
	modo = 1

func calcula_tamanho_traco():
	if tracos.size() >= 2:
		tam_traco = 0
		for i in (tracos.size() - 1):
			tam_traco = tam_traco + sqrt(pow((tracos[i][0] - tracos[i+1][0])/100, 2)
				+ pow((tracos[i][1] - tracos[i+1][1])/100, 2))
			print(sqrt(pow((tracos[i][0] - tracos[i+1][0])/100, 2)
				+ pow((tracos[i][1] - tracos[i+1][1])/100, 2)))
			print(tam_traco)
		get_node("../UI/ProgressBar").value = 100*(tam_traco/max_tam_traco)
