extends Node2D

var nodes = Array()            #tableau des noeuds de notre plateau
var maxX = 50                  #nb de noeuds en X
var maxY = 30                  #nb de noeuds en Y

var stepX = 32                 #modifier pour changer la taille en pixels du plateau, mettre des valeurs paires
var stepY = int(stepX * 0.866) #ne pas modifier, 0.866 est le ratio pour un triangle equilateral

var padding = 100              #définit l'espace entre le plateau et le bord
var lineWidth = 2              #définit la largeur des lignes entre les triangles, mettre des valeurs paires

var maxDist = 500

#modèle pour un noeud
var Noeud = {
	"tri": Array(),            #tableau des indices des triangles, permet de faciliter le changement de couleur
	"pos": Vector2(),          #position du noeud
	"selected": bool()
}

#couleurs disponibles pour les triangles
var mat1 = load("res://materials/default_triangle_material.tres")            #par defaut, blanc
var mat2 = load("res://materials/selected_triangle_material.tres")           #selectionné, bleu
var mat3 = load("res://materials/default_overlayed_triangle_material.tres")  #sous la souris, gris

#fonctions de génération
#remplit le tableau de noeuds avec la bonne position
func genererNoeuds():
	for i in range(0, maxX * maxY):
		var p = Noeud.duplicate() #création d'une instance d'un noeud
		p.pos.x = (i % maxX) * stepX + ((int(i / maxX) % 2) * int(stepX / 2)) + padding
		p.pos.y = int(i / maxX) * stepY + padding
		p.tri = [0, 0, 0, 0, 0, 0] #initialisation après instanciation car sinon il y a conflit d'adresses
		p.selected = false
		nodes.append(p)

#fonction qui génère les triangles du plateau ainsi que ses attributs
func genererTriangles():
	#triangle bas-gauche, les autres triangles seront moins détaillés comme le procédé est similaire
	for i in range(0, (maxX + 1) * maxY):
		var st = SurfaceTool.new() #outil qui permet de créer un polygone
		st.begin(Mesh.PRIMITIVE_TRIANGLES) 
		var tempM = Mesh.new()     #création d'un instance de polygone (ne possède pas encore de donnée)
		
		#comme la position des points est relative à la position d'un noeud, on calcule cette position avant de créer les points
		var px = (i % (maxX + 1)) * stepX + ((int(i / (maxX + 1)) % 2) * int(stepX / 2)) + (padding - stepX)
		var py = int(i / (maxX + 1)) * stepY + padding
		
		#création des points
		st.add_vertex(Vector3(px + lineWidth, py + int(lineWidth / 2), 0))
		st.add_vertex(Vector3(px + stepX - lineWidth, py + int(lineWidth / 2), 0))
		st.add_vertex(Vector3(px + int(stepX / 2), py + stepY - lineWidth, 0))
		
		#stockage du triangle dans l'instance de polygone
		st.commit(tempM)
		#ajout du polygone à une mesh instance (comporte d'autres attributs comme la couleur)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		meshI.material = mat1
		#ajout de la mesh instance à notre scène de jeu
		add_child(meshI)
		
		#calcul de la position dans le tableau de noeuds (à décaler dans une fonction externe)
		var x = i % (maxX + 1)
		var y = int(i / (maxX + 1))
		
		#bas-gauche sauf pour le dernier (le dernier X n'est pas un noeud à proprement parler)
		if not (x == maxX):
			nodes[i - y].tri[0] = i
		#bas-droite sauf pour le premier noeud (il n'y a pas de noeud avant le premier)
		if not (x == 0):
			nodes[i - y - 1].tri[4] = i
		#haut, différent selon le décalage, sauf pour la dernière ligne
		if (not (x == 0)) and (y % 2 == 0) and (not (y == maxY - 1)):
			nodes[i - y - 1 + maxX].tri[2] = i
		elif (not (x == maxX)) and (y % 2 == 1) and (not (y == maxY - 1)):
			nodes[i - y + maxX].tri[2] = i
	
	#haut-gauche
	for i in range(0, (maxX + 1) * maxY):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % (maxX + 1)) * stepX + ((int(i / (maxX + 1)) % 2) * int(stepX / 2)) + (padding - stepX)
		var py = int(i / (maxX + 1)) * stepY + padding
		st.add_vertex(Vector3(px + lineWidth, py - int(lineWidth / 2), 0))
		st.add_vertex(Vector3(px + stepX - lineWidth, py - int(lineWidth / 2), 0))
		st.add_vertex(Vector3(px + int(stepX / 2), py - (stepY - lineWidth), 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		meshI.material = mat1
		add_child(meshI)
		
		var x = i % (maxX + 1)
		var y = int(i / (maxX + 1))
		
		var index = i + (maxX + 1) * maxY
		
		if not (x == maxX):
			nodes[i - y].tri[1] = index
		if not (x == 0):
			nodes[i - y - 1].tri[3] = index
		if (not (x == 0)) and (y % 2 == 0) and (not (y == 0)):
			nodes[i - y - 1 - maxX].tri[5] = index
		elif (not (x == maxX)) and (y % 2 == 1) and (not (y == 0)):
			nodes[i - y - maxX].tri[5] = index
	
	#exception de la ligne du haut
	for i in range(0, maxX):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % maxX) * stepX + padding
		var py = padding
		st.add_vertex(Vector3(px, py - lineWidth, 0))
		st.add_vertex(Vector3(px - (int(stepX / 2) - lineWidth - 1), py - (stepY - lineWidth), 0))
		st.add_vertex(Vector3(px + (int(stepX / 2) - lineWidth - 1), py - (stepY - lineWidth), 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		meshI.material = mat1
		add_child(meshI)
		
		var index = i + (maxX + 1) * maxY * 2
		nodes[i].tri[2] = index
	
	#exception de la ligne du bas
	for i in range(0, maxX):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var tempM = Mesh.new()
		var px = (i % maxX) * stepX + padding + (((maxY + 1) % 2) * int(stepX / 2))
		var py = padding + (maxY - 1) * stepY
		st.add_vertex(Vector3(px, py + lineWidth, 0))
		st.add_vertex(Vector3(px - (int(stepX / 2) - lineWidth - 1), py + stepY - lineWidth, 0))
		st.add_vertex(Vector3(px + (int(stepX / 2) - lineWidth - 1), py + stepY - lineWidth, 0))
		st.commit(tempM)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		meshI.material = mat1
		add_child(meshI)
		
		var index = i + (maxX + 1) * maxY * 2 + maxX
		nodes[maxX * (maxY - 1) + i].tri[5] = index



#fonctions exécutées pendant le déroulement du programme

#évènements
func _unhandled_input(event):
	#click gauche, fait disparaitre les triangles du noeud cliqué (débeuggage)
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		var cursorPos = get_viewport().get_mouse_position()
		var minDist = 10000
		var dist
		var index = 0
		#calcule l'indice du noeud le plus proche de la souris
		for i in range(0, maxX * maxY):
			dist = cursorPos.distance_to(nodes[i].pos)
			if dist < minDist:
				minDist = dist
				index = i
		if get_child((maxX + 1) * maxY * 2 + maxX * 2).position == nodes[index].pos: # le pion est ajouté après les points
			for i in range(0, maxX * maxY):
				if nodes[index].pos.distance_to(nodes[i].pos) < maxDist:
					get_child(nodes[i].tri[0]).material = mat2 #permet d'accéder à un triangle
					get_child(nodes[i].tri[1]).material = mat2
					get_child(nodes[i].tri[2]).material = mat2
					get_child(nodes[i].tri[3]).material = mat2
					get_child(nodes[i].tri[4]).material = mat2
					get_child(nodes[i].tri[5]).material = mat2
					nodes[i].selected = true
			
		
		
	
	#click droit, fait réapparaitre tous les triangles (débeuggage)
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		for i in range(0, maxX * maxY):
			get_child(nodes[i].tri[0]).material = mat1
			get_child(nodes[i].tri[1]).material = mat1
			get_child(nodes[i].tri[2]).material = mat1
			get_child(nodes[i].tri[3]).material = mat1
			get_child(nodes[i].tri[4]).material = mat1
			get_child(nodes[i].tri[5]).material = mat1

func _process(delta):
	var cursorPos = get_viewport().get_mouse_position()
	var minDist = 10000
	var dist
	var index = 0
	#calcule l'indice du noeud le plus proche de la souris
	for i in range(0, maxX * maxY):
		dist = cursorPos.distance_to(nodes[i].pos)
		if dist < minDist:
			minDist = dist
			index = i
	pass


#fonction appelée lors du la création du noeud
func _init():
	genererNoeuds()
	genererTriangles()
	
