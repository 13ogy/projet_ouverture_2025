# projet_ouverture_2025

Fonctionnalités
- Générateurs d’arbres:
  - Rémy (naïf)
  - Rémy (linéaire)
  - ABR (choix uniforme d’une feuille)
- Métriques: hauteur, largeur (nœuds internes), profondeur moyenne des feuilles, taille du sous-arbre gauche

Prérequis
- OCaml (recommandé via Homebrew: brew install ocaml)
- dune (brew install dune)
- (optionnel) graphviz pour convertir manuellement les .dot en images (brew install graphviz)

Build
- make build
- ou: dune build

Exécution:
- Sans argument (n=10 par défaut):
  - make run
  - ou: dune exec src/main.exe
- Avec un n spécifique:
  - make 1000
  - dune exec src/main.exe -- 1000
Ce programme:
- génère un arbre via Rémy (linéaire),
- affiche des métriques,
- écrit un fichier DOT: graphs/sample_remy_lineaire_n{n}.dot

Pour conversion Graphviz: 
- Exemple:
  dot -Tpng graphs/sample_remy_lineaire_n10.dot -o graphs/sample_remy_lineaire_n10.png

Expérimentations
- make experiments
- ou: dune exec src/experiments.exe
Résultats:
- CSV: data/experiments.csv

Tests
- make test
- ou: dune runtest
  Résultats:
- CSV: data/stats.csv

Structure du code
- src/types.ml: Types.Common (arbre simple), Types.Naive, Types.Lineaire
- src/remy_naive.ml: Rémy naïf (+ to_common)
- src/remy_lineaire.ml: Rémy linéaire (+ to_common)
- src/abr.ml: ABR (+ to_common)
- src/metrics.ml: métriques
- src/dot.ml: export .dot
- src/experiments.ml: exécutable d’expérimentations
- src/main.ml: démo simple pour make
- tests/tests.ml: tests
