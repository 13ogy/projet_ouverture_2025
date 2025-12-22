open Types.Common

(* Hauteur de l'arbre. *)
let rec height t =
  match t with
  | Leaf -> 0
  | Node (g, d) ->
      let hg = height g in
      let hd = height d in
      1 + (if hg > hd then hg else hd)

(* Compteur du nombre de nœuds internes. *)
let rec internal_count t =
  match t with
  | Leaf -> 0
  | Node (g, d) -> 1 + internal_count g + internal_count d

(* Compte le nombre de feuilles dans l'arbre. *)
let rec leaf_count t =
  match t with
  | Leaf -> 1
  | Node (g, d) -> leaf_count g + leaf_count d

(* Largeur maximale de l'arbre, en ne comptant que les nœuds internes *)
let width_internal t =
  (* incrémente un compteur associé à une profondeur "depth" dans une liste d'associations *)
  let rec incr_depth depth acc =
    match acc with
    | [] -> [ (depth, 1) ]
    | (d, c) :: q ->
        if d = depth then (d, c + 1) :: q
        else (d, c) :: incr_depth depth q
  in
  (* parcours DFS accumulant les comptes par profondeur *)
  let rec aux arbre depth acc =
    match arbre with
    | Leaf -> acc
    | Node (g, d) ->
        let acc1 = incr_depth depth acc in
        let acc2 = aux g (depth + 1) acc1 in
        aux d (depth + 1) acc2
  in
  let counts = aux t 0 [] in
  (* maximum des comptes *)
  let rec max_count l m =
    match l with
    | [] -> m
    | (_, c) :: q ->
        let m2 = if c > m then c else m in
        max_count q m2
  in
  max_count counts 0

(* Profondeurs de toutes les feuilles. *)
let leaf_depths t =
  let rec aux arbre depth acc =
    match arbre with
    | Leaf -> depth :: acc
    | Node (g, d) ->
        let acc1 = aux g (depth + 1) acc in
        aux d (depth + 1) acc1
  in
  aux t 0 []

(* Profondeur moyenne des feuilles. *)
let avg_leaf_depth t =
  let l = leaf_depths t in
  match l with
  | [] -> 0.0
  | _ ->
      let sum =
        List.fold_left (fun s x -> s + x) 0 l
      in
      (float_of_int sum) /. (float_of_int (List.length l))

(* Taille (en nœuds internes) du sous-arbre gauche de la racine. *)
let left_subtree_size t =
  match t with
  | Leaf -> 0
  | Node (g, _) -> internal_count g

(* Égalité structurelle de deux arbres binaires simples. *)
let rec equal t1 t2 =
  match t1, t2 with
  | Leaf, Leaf -> true
  | Node (g1, d1), Node (g2, d2) -> (equal g1 g2) && (equal d1 d2)
  | _ -> false
