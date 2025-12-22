# projet_ouverture_2025

Build
```
 make build
 ou: dune build
```
---
Exécution:
- Sans argument (n=10 par défaut):
  ```
  make run
  ```
  ou:
  ```
  dune exec src/main.exe
  ```
- Avec un n spécifique:
 - p.e.
  ```
  make 1000
  ```
  ou:
  ```
  dune exec src/main.exe -- 1000
  ```
Ce programme:
- génère un arbre via Rémy (linéaire),
- affiche des métriques,
- écrit un fichier DOT: graphs/sample_remy_lineaire_n{n}.dot
---
Pour conversion Graphviz: 
- p.e.
  ```
  dot -Tpng graphs/sample_remy_lineaire_n10.dot -o graphs/sample_remy_lineaire_n10.png
  ```
---
Expérimentations
```
make experiments
```
ou: 
```
dune exec src/experiments.exe
```
Résultats:
- CSV: data/experiments.csv
---
Tests
```
make test
```
ou: 
```
dune runtest
```
  Résultats:
- CSV: data/stats.csv

---

Versions utilisées:
OCaml 5.4.0 & Dune 3.20.2

---

Structure du code
```
- src/types.ml: Types.Common (arbre simple), Types.Naive, Types.Lineaire
- src/remy_naive.ml: Rémy naïf
- src/remy_lineaire.ml: Rémy linéaire
- src/abr.ml: ABR
- src/metrics.ml: métriques
- src/dot.ml: export .dot
- src/experiments.ml: exécutable d’expérimentations
- src/main.ml: démo simple pour make
- tests/tests.ml: tests
```
