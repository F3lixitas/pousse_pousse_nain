# ATTENTION : Cette version marche parfaitement mais elle est à chier en terme d'optimisation
#
#Car on parcours même les chemins nons valide. Voir fichier sauv fct dep avec beug mais economie.txt pour éviter de faire ça
# Si on fait pas ça, on peut avoir des beugs. Es ce possible de trouver un compromis ?


extends Node

const pointOperations = preload("res://scripts/pointOperations_script.gd")

static func verfifAllDep(posInit, dep, node):
	##### Variable #######
	var Chemin = {
		"dir": [0, 0, 0, 0, 0, 0],             
		"rang" : int(),
		"valide" : int(), # 1 pour valide, 0 pour non valide 
				#J'ai rajouter cette option car les chemins nons valide doivent continuer d'être tester. Car si ils tombent sur une case occupé, ils doivent avertir leur voisin !
				# Tester les chemins non valides rajoute bcp de tests inutile, mais j'ai pas trouvé mieux.
	}
	var cheminsBase = Array()
	var cheminsCourant = Array()
	
	var indicesOK = Array()

	
	##### initialisation (pour l'étage 1) ######
	for i in range(0, 6):
		var monChemin = Chemin.duplicate(true)
		monChemin.dir[i] = 1
		monChemin.rang = 1
		if dep[i] == 1 and pointOperations.checkValidity(node.points[posInit].neighbour[i], node):
			#Pour les chemins de bases, il faudra aussi vérifier les colisions !!! Utilise si quelqu'un nous touche deirectement
			monChemin.valide = 1
			indicesOK.append(node.points[posInit].neighbour[i])
		else:
			monChemin.valide = 0
		cheminsCourant.push_back(monChemin)
		
	#### Programme (a partir de l'étage 2) ######
	for etageCourant in range(2, 20):
		
		#print("ETAGE n", etageCourant)
		
		#### Initialisation des tableaux chemins
		cheminsBase = cheminsCourant.duplicate(true)
		cheminsCourant = Array()
		
		#### Création des nouveaux chemins  ######
		# note : dans le cas d'une suppression, on met rang = 0 mais on ne le supprime pas physiquement
		for j in range(0, cheminsBase.size() - 1):
			# on ducplique notre chemin dans le nouveau
			cheminsCourant.push_back(cheminsBase[j].duplicate(true))
			
			# on créer un chemin intermédiaire après si besoin
			if cheminsBase[j].rang + cheminsBase[j + 1].rang == etageCourant:
				var monChemin = Chemin.duplicate(true)
				monChemin.rang = etageCourant
				monChemin.valide = cheminsBase[j].valide*cheminsBase[j+1].valide
				for dirCourant in range(0, 6):
					monChemin.dir[dirCourant] = cheminsBase[j].dir[dirCourant] + cheminsBase[j + 1].dir[dirCourant]
				cheminsCourant.push_back(monChemin.duplicate(true))

		# le dernier chemin subit les même opération mais par rapport au premier, car l'ensemble des chemins fait le tour du personnage
		cheminsCourant.push_back(cheminsBase[cheminsBase.size()-1].duplicate(true))
		if cheminsBase[cheminsBase.size()-1].rang + cheminsBase[0].rang == etageCourant:
			var monChemin = Chemin.duplicate(true)
			monChemin.rang = etageCourant
			monChemin.valide = cheminsBase[cheminsBase.size()-1].valide*cheminsBase[0].valide
			for dirCourant in range(0, 6):
				monChemin.dir[dirCourant] = cheminsBase[cheminsBase.size()-1].dir[dirCourant] + cheminsBase[0].dir[dirCourant]
			cheminsCourant.push_back(monChemin.duplicate(true))
		
		# print(cheminsCourant)
		
		### Vérification des cases à l'étage courant pour chaque chemin ###
		for j in range(0, cheminsCourant.size()):
			if etageCourant % cheminsCourant[j].rang == 0:
				#On récup l'indice de la case en passant par tous les voisins depuis le point de départ
				var indiceCourant = posInit
				for dirCourant in range(0, 6):
					for cmp in range(0, cheminsCourant[j].dir[dirCourant] * int(etageCourant/cheminsCourant[j].rang)):
						if indiceCourant >= 0 :
							indiceCourant = node.points[indiceCourant].neighbour[dirCourant]
				
				#Si la case est occupé, alors on dévalide la case et les alentours
				if pointOperations.checkValidity(indiceCourant, node) == false:
					# la case est occupé, donc on suppr le chemin et tous les chemins autours qui n'ont pas de point à cet étage
					
					#Chemin courant
					cheminsCourant[j].valide = 0
					
					#Chemin avant
					var indiceTest = j
					
					while true:
						if indiceTest - 1 >= 0:
							indiceTest = indiceTest - 1
						else:
							indiceTest = cheminsCourant.size() - 1
						
						if etageCourant % cheminsCourant[indiceTest].rang == 0:
							break
						else:
							cheminsCourant[indiceTest].valide = 0
							
					#Chemin après
					indiceTest = j
					
					while true:
						if indiceTest + 1 < cheminsCourant.size():
							indiceTest = indiceTest + 1
						else:
							indiceTest = 0
						
						if etageCourant % cheminsCourant[indiceTest].rang == 0:
							break
						else:
							cheminsCourant[indiceTest].valide = 0
							
				else: if cheminsCourant[j].valide == 1:
					indicesOK.append(indiceCourant)
				#print("indice : ", indiceCourant)		
				
				
	return indicesOK


