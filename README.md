# Pousse-pousse Nain
Un jeu adapté du jeux de société éponyme

Lien vers la documentation Godot : https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html

## Génération du plateau :
- génération des noeuds et de leur position.
- génération des triangles du plateau en 4 étapes : en bas à gauche (0), en hau à droite (1), exception de la ligne du haut et exception de la ligne du bas

En itérant sur X + 1 on peut faire l'exeception des bords droite et gauche dans la foulée.

Un triangle est partagé par 3 noeuds (sauf exception des bords).

Le triangle en bas à gauche peut être en position 0, 2 et 4. Le triangle en haut à gauche peut être en position 1, 3 et 5.

![indexage_triangles](https://user-images.githubusercontent.com/69387907/124366998-07228b00-dc54-11eb-9966-c6420312ffdf.png)
