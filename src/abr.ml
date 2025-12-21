(* src/abr.ml *)
open Types.Lineaire

type abr_tree = {
  root : btree_ref;          (* racine de l'arbre *)
  leaves : btree_ref array;  (* tableau des feuilles actuelles *)
  mutable lsize : int;       (* nombre de feuilles effectives *)
}

(* Initialise une structure pour construire un arbre ABR de taille n. *)
let create n =
  let root = ref Leaf in
  let leaves = Array.make (n + 1) root in
  { root = root; leaves = leaves; lsize = 1 }

(* Une étape de l'algorithme ABR. *)
let step (t : abr_tree) =
  (* choix d'une feuille aléatoire*)
  let i = Random.int t.lsize in
  let feuille_choisie = t.leaves.(i) in

  let l = ref Leaf in
  let r = ref Leaf in
  feuille_choisie := Node (l, r);

  (* on remplace la feuille choisie par l'enfant gauche,
     et on ajoute le nouvel enfant droit en fin de tableau des feuilles *)
  t.leaves.(i) <- l;
  t.leaves.(t.lsize) <- r;
  t.lsize <- t.lsize + 1

(* Construit un arbre ABR de taille n (n nœuds internes). *)
let abr n =
  let t = create n in
  let rec aux k =
    match k with
    | 0 -> t
    | _ ->
        step t;
        aux (k - 1)
  in
  aux n

(* Conversion de l'arbre ABR vers le type commun *)
let to_common (t : abr_tree) =
  let rec aux node =
    match !node with
    | Leaf -> Types.Common.Leaf
    | Node (g, d) -> Types.Common.Node (aux g, aux d)
  in
  aux t.root

(* Construction directe d'un arbre commun via ABR *)
let abr_common n =
  let t = abr n in
  to_common t
