extends Node



static func verfifAllDep(posInit, dep, node):
	##### Variable #######
	var Chemin = {
		"dir": [0, 0, 0, 0, 0, 0],             
		"rang" : int(),      
	}
	var cheminsBase = Array()
	var cheminsCourant = Array()
	
	var indicesOK = Array()

	
	##### initialisation (pour l'étage 1) ######
	for i in range(0, 6):
		var monChemin = Chemin.duplicate(true)
		monChemin.dir[i] = 1
		if dep[i] == 1:
			#Pour les chemins de bases, il faudra aussi vérifier les colisions !!! Utilise si quelqu'un nous touche deirectement
			monChemin.rang = 1
			indicesOK.append(node.points[posInit].neighbour[i])
		else:
			monChemin.rang = 0
		cheminsCourant.push_back(monChemin)
		
	#### Programme (a partir de l'étage 2) ######
	for etageCourant in range(2, 10):
		
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
				for dirCourant in range(0, 6):
					monChemin.dir[dirCourant] = cheminsBase[j].dir[dirCourant] + cheminsBase[j + 1].dir[dirCourant]
				cheminsCourant.push_back(monChemin.duplicate(true))

		# le dernier chemin subit les même opération mais par rapport au premier, car l'ensemble des chemins fait le tour du personnage
		cheminsCourant.push_back(cheminsBase[cheminsBase.size()-1].duplicate(true))
		if cheminsBase[cheminsBase.size()-1].rang + cheminsBase[0].rang == etageCourant:
			var monChemin = Chemin.duplicate(true)
			monChemin.rang = etageCourant
			for dirCourant in range(0, 6):
				monChemin.dir[dirCourant] = cheminsBase[cheminsBase.size()-1].dir[dirCourant] + cheminsBase[0].dir[dirCourant]
			cheminsCourant.push_back(monChemin.duplicate(true))
		
		# print(cheminsCourant)
		
		### Vérification des cases à l'étage courant pour chaque chemin ###
		for j in range(0, cheminsCourant.size()):
			if cheminsCourant[j].rang != 0 and etageCourant % cheminsCourant[j].rang == 0:
				#print(cheminsCourant[j])
				
				#On récup l'indice de la case en passant par tous les voisins depuis le point de départ
				var indiceCourant = posInit
				for dirCourant in range(0, 6):
					for cmp in range(0, cheminsCourant[j].dir[dirCourant] * int(etageCourant/cheminsCourant[j].rang)):
						if indiceCourant >= 0:
							indiceCourant = node.points[indiceCourant].neighbour[dirCourant]
							
				indicesOK.append(indiceCourant)
				#print("indice : ", indiceCourant)			
	return indicesOK


