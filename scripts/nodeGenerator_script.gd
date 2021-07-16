extends Node2D

#################################   Importation de codes source   #################################

const triangleGenerator = preload("res://scripts/triangleGenerator_script.gd")

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
	"tri": Array()              # Tableau des indices des triangles, permet de faciliter le changement de couleur
}

##################################   Importation de ressources   ##################################

# Couleurs disponibles pour les triangles

const defaultMaterial   = preload("res://materials/default_triangle_material.tres")               # par défaut, blanc
const selectedMaterial  = preload("res://materials/selected_triangle_material.tres")              # Selectionné, bleu
const overlayedMaterial = preload("res://materials/default_overlayed_triangle_material.tres")     # Sous la souris, gris

##########################################   Fonctions   ##########################################

# Remplit le tableau de points avec la bonne position

func genererPoints():
	for i in range(0, maxX * maxY):
		var p = Point.duplicate() #création d'une instance d'un noeud
		p.tri = [0, 0, 0, 0, 0, 0] #initialisation après instanciation car sinon il y a conflit d'adresses
		points.append(p)


# Evènements

func _unhandled_input(event):
	
	# Click gauche
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		pass


# Fonction appelée lors du la création du noeud

func _init():
	genererPoints()
	triangleGenerator.generateTriangles(maxX, maxY, stepX, stepY, padding, lineWidth, defaultMaterial, get_node("."))
