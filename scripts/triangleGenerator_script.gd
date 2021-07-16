extends Node

# Fichier contenant les fonctions necessaires à la génération des triangles sur le plateau de jeu

static func generateTriangles(maxX, maxY, stepX, stepY, padding, lineWidth, material, node):
	# Triangle bas-gauche, les autres triangles seront moins détaillés comme le procédé est similaire
	for i in range(0, (maxX + 1) * maxY):
		var st = SurfaceTool.new()           # Outil qui permet de créer un polygone
		st.begin(Mesh.PRIMITIVE_TRIANGLES) 
		var tempM = Mesh.new()               # Création d'un instance de polygone (ne possède pas encore de donnée)
		
		# Comme la position des points est relative à la position d'un noeud, on calcule cette position avant de créer les points
		var px = (i % (maxX + 1)) * stepX + ((int(i / (maxX + 1)) % 2) * int(stepX / 2)) + (padding - stepX)
		var py = int(i / (maxX + 1)) * stepY + padding
		
		# Création des points
		st.add_vertex(Vector3(px + lineWidth, py + int(lineWidth / 2), 0))
		st.add_vertex(Vector3(px + stepX - lineWidth, py + int(lineWidth / 2), 0))
		st.add_vertex(Vector3(px + int(stepX / 2), py + stepY - lineWidth, 0))
		
		# Stockage du triangle dans l'instance de polygone
		st.commit(tempM)
		# Ajout du polygone à une mesh instance (comporte d'autres attributs comme la couleur)
		var meshI = MeshInstance2D.new()
		meshI.mesh = tempM
		meshI.material = material
		# Ajout de la mesh instance à notre scène de jeu
		node.add_child(meshI)
		
		# Calcul de la position dans le tableau de noeuds (à décaler dans une fonction externe)
		var x = i % (maxX + 1)
		var y = int(i / (maxX + 1))
		
		# Bas-gauche sauf pour le dernier (le dernier X n'est pas un noeud à proprement parler)
		if not (x == maxX):
			node.points[i - y].tri[0] = i
		# Bas-droite sauf pour le premier noeud (il n'y a pas de noeud avant le premier)
		if not (x == 0):
			node.points[i - y - 1].tri[4] = i
		# Haut, différent selon le décalage, sauf pour la dernière ligne
		if (not (x == 0)) and (y % 2 == 0) and (not (y == maxY - 1)):
			node.points[i - y - 1 + maxX].tri[2] = i
		elif (not (x == maxX)) and (y % 2 == 1) and (not (y == maxY - 1)):
			node.points[i - y + maxX].tri[2] = i
	
	# Haut-gauche
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
		meshI.material = material
		node.add_child(meshI)
		
		var x = i % (maxX + 1)
		var y = int(i / (maxX + 1))
		
		var index = i + (maxX + 1) * maxY
		
		if not (x == maxX):
			node.points[i - y].tri[1] = index
		if not (x == 0):
			node.points[i - y - 1].tri[3] = index
		if (not (x == 0)) and (y % 2 == 0) and (not (y == 0)):
			node.points[i - y - 1 - maxX].tri[5] = index
		elif (not (x == maxX)) and (y % 2 == 1) and (not (y == 0)):
			node.points[i - y - maxX].tri[5] = index
	
	# Exception de la ligne du haut
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
		meshI.material = material
		node.add_child(meshI)
		
		var index = i + (maxX + 1) * maxY * 2
		node.points[i].tri[2] = index
	
	# Exception de la ligne du bas
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
		meshI.material = material
		node.add_child(meshI)
		
		var index = i + (maxX + 1) * maxY * 2 + maxX
		node.points[maxX * (maxY - 1) + i].tri[5] = index
