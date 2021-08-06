extends Node2D

#################################   Importation de codes source   #################################

const triangleGenerator = preload("res://scripts/triangleGenerator_script.gd")
const pointOperations = preload("res://scripts/pointOperations_script.gd")
const deplacement = preload("res://scripts/deplacement.gd")

##################################   Importation de ressources   ##################################

# Couleurs disponibles pour les triangles

const defaultMaterial   = preload("res://materials/default_triangle_material.tres")               # par défaut, blanc
const selectedMaterial  = preload("res://materials/selected_triangle_material.tres")              # Selectionné, bleu
const overlayedMaterial = preload("res://materials/default_overlayed_triangle_material.tres")     # Sous la souris, gris
const occupiedMaterial = preload("res://materials/occupied_triangle_material.tres")               # Occupé, gris foncé

##################################   Déclaration des variables   ##################################

var points = Array()            # Tableau des noeuds de notre plateau
var maxX = 50                   # Nb de noeuds en X
var maxY = 30                   # Nb de noeuds en Y

var stepX = 32                  # Modifier pour changer la taille en pixels du plateau, mettre des valeurs paires
var stepY = int(stepX * 0.866)  # Ne pas modifier, 0.866 est le ratio pour un triangle equilateral

var padding = 100               # Définit l'espace entre le plateau et le bord
var lineWidth = 2               # Définit la largeur des lignes entre les triangles, mettre des valeurs paires

# Modèle pour un point
var Point = {
	"tri": Array(),             # Tableau des indices des triangles, permet de faciliter le changement de couleur
	"occupation" : int(),       # Indique quelle pièce occupe le point (0 = inoccupée)
	"neighbour" : Array()
}

var selected = Array()

var t = Timer

var lastMaterials = [defaultMaterial, defaultMaterial, defaultMaterial, defaultMaterial, defaultMaterial, defaultMaterial]
var overlayed = 0

var pionIndex = (maxX + 1) * maxY * 2 + 2 * maxX



##########################################   Fonctions   ##########################################

# Remplit le tableau de points avec la bonne position

func changeMaterial(index, material):
	get_child(points[index].tri[0]).material = material
	get_child(points[index].tri[1]).material = material
	get_child(points[index].tri[2]).material = material
	get_child(points[index].tri[3]).material = material
	get_child(points[index].tri[4]).material = material
	get_child(points[index].tri[5]).material = material


func genererPoints():
	for i in range(0, maxX * maxY):
		var p = Point.duplicate() #création d'une instance d'un noeud
		p.tri = [0, 0, 0, 0, 0, 0] #initialisation après instanciation car sinon il y a conflit d'adresses
		p.occupation = 0
		p.neighbour = [-1, -1, -1, -1, -1, -1]

		var pos = pointOperations.splitXY(maxX, maxY, i)
		
		if int(pos.y) % 2 == 0:
			p.neighbour[0] = i + maxX - 1
			p.neighbour[1] = i - 1
			p.neighbour[2] = i - maxX - 1
			p.neighbour[3] = i - maxX
			p.neighbour[4] = i + 1
			p.neighbour[5] = i + maxX
		else:
			p.neighbour[0] = i + maxX
			p.neighbour[1] = i - 1
			p.neighbour[2] = i - maxX
			p.neighbour[3] = i - maxX + 1
			p.neighbour[4] = i + 1
			p.neighbour[5] = i + maxX + 1
		
		if pos.y == 0:
			p.neighbour[2] = -1
			p.neighbour[3] = -1
		if pos.y == maxY - 1:
			p.neighbour[0] = -1
			p.neighbour[5] = -1
		
		if pos.x == 0:
			p.neighbour[1] = -1
			if int(pos.y) % 2 == 0:
				p.neighbour[0] = -1
				p.neighbour[2] = -1
		if pos.x == maxX - 1:
			p.neighbour[4] = -1
			if int(pos.y) % 2 == 1:
				p.neighbour[3] = -1
				p.neighbour[5] = -1
		
		points.append(p)

# Cette fonction sert principalement pour le débeug
func redraw():
	for i in range(0, maxX * maxY):
		if pointOperations.checkValidity(i, get_node(".")) :
			get_child(points[i].tri[0]).material = defaultMaterial
			get_child(points[i].tri[1]).material = defaultMaterial
			get_child(points[i].tri[2]).material = defaultMaterial
			get_child(points[i].tri[3]).material = defaultMaterial
			get_child(points[i].tri[4]).material = defaultMaterial
			get_child(points[i].tri[5]).material = defaultMaterial
		elif not points[i].occupation == 0:
			get_child(points[i].tri[0]).material = occupiedMaterial
			get_child(points[i].tri[1]).material = occupiedMaterial
			get_child(points[i].tri[2]).material = occupiedMaterial
			get_child(points[i].tri[3]).material = occupiedMaterial
			get_child(points[i].tri[4]).material = occupiedMaterial
			get_child(points[i].tri[5]).material = occupiedMaterial
	pass

# Evènements

func _unhandled_input(event):
	
	# Click gauche
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		var mp = get_viewport().get_mouse_position()
		
		var index = pointOperations.getPointIndex(maxX, maxY, stepX, stepY, padding, mp)
		
		var tab = deplacement.verfifAllDep(index, [1, 1, 1, 1, 1, 1], get_node("."))
		
		for cmp in range(0, tab.size()):
			changeMaterial(tab[cmp], selectedMaterial)
			selected.append(tab[cmp])
			var p = Sprite.new()
			p.texture = load("res://images/noeud.png")
			p.position = pointOperations.getPointPosition(maxX, maxY, stepX, stepY, padding, tab[cmp])
			p.scale = Vector2(0.1, 0.1)
			add_child(p)
		
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		#remise par défaut
		for i in range(0, selected.size()):
			get_child(points[selected[i]].tri[0]).material = defaultMaterial
			get_child(points[selected[i]].tri[1]).material = defaultMaterial
			get_child(points[selected[i]].tri[2]).material = defaultMaterial
			get_child(points[selected[i]].tri[3]).material = defaultMaterial
			get_child(points[selected[i]].tri[4]).material = defaultMaterial
			get_child(points[selected[i]].tri[5]).material = defaultMaterial
		selected.clear()

# Fonction appelée lors du la création du noeud

func _process(delta):
	var mp = get_viewport().get_mouse_position()
		
	var index = pointOperations.getPointIndex(maxX, maxY, stepX, stepY, padding, mp)
	
	get_child(points[overlayed].tri[0]).material = lastMaterials[0]
	get_child(points[overlayed].tri[1]).material = lastMaterials[1]
	get_child(points[overlayed].tri[2]).material = lastMaterials[2]
	get_child(points[overlayed].tri[3]).material = lastMaterials[3]
	get_child(points[overlayed].tri[4]).material = lastMaterials[4]
	get_child(points[overlayed].tri[5]).material = lastMaterials[5]
	
	lastMaterials[0] = get_child(points[index].tri[0]).material
	lastMaterials[1] = get_child(points[index].tri[1]).material
	lastMaterials[2] = get_child(points[index].tri[2]).material
	lastMaterials[3] = get_child(points[index].tri[3]).material
	lastMaterials[4] = get_child(points[index].tri[4]).material
	lastMaterials[5] = get_child(points[index].tri[5]).material
	
	get_child(points[index].tri[0]).material = overlayedMaterial
	get_child(points[index].tri[1]).material = overlayedMaterial
	get_child(points[index].tri[2]).material = overlayedMaterial
	get_child(points[index].tri[3]).material = overlayedMaterial
	get_child(points[index].tri[4]).material = overlayedMaterial
	get_child(points[index].tri[5]).material = overlayedMaterial
	
	overlayed = index

func _init():
	genererPoints()
	
	triangleGenerator.generateTriangles(maxX, maxY, stepX, stepY, padding, lineWidth, defaultMaterial, get_node("."))
	points[931].occupation = 1
	points[235].occupation = 1
	points[764].occupation = 1
	points[147].occupation = 1
	points[632].occupation = 1
	redraw()
