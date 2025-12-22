(* src/remy_naive.ml *)
open Types.Naive

(* Compte le nombre de nœuds dans l'arbre *)
let rec cpt_node (tree)=
  match tree with
  | Leaf -> 1
  | Node (g,d)->1+cpt_node(g)+cpt_node(d)

(*choisir aleatoirement si le noeud devient fils gauche ou fiche droit d'un nouveau noeud*)
let fils_rand (node)=
  let fils = Random.int 2 in
  match fils with
  |0->Node(node,Leaf)
  |1->Node(Leaf,node)
  |_ -> failwith "Impossible"

(*une tape de l'algorithme de Remy*)
let step_remy (tree, k) =
  let node_ident = Random.int k in
  (*La fonction retourne (nouvel_arbre, prochain_index_libre)*)
  let rec choix_cpt (t, cpt) =
    if cpt = node_ident then (*si le nœud est le bon, on l'étend*)
      (fils_rand t, cpt + 1)
    else
      match t with
      | Leaf -> (Leaf, cpt + 1) (*si on atteint une feuille, on passe à la suite *)
      | Node (g, d) ->
          (*on cherche d'abord dans le fils gauche *)
          let g2, cpt_apres_g = choix_cpt (g, cpt + 1) in
          if cpt_apres_g > node_ident then (*si on l'a trouvé a gauche*)
            (Node (g2, d), cpt_apres_g)
          else (*sinon on cherche dans le fils droit *)
            let d2, cpt_final = choix_cpt (d, cpt_apres_g) in
            (Node (g, d2), cpt_final)        
  in let res, _ = choix_cpt (tree, 0) in res


(*fonction principale*)
let rec remy (n)=
  match n with
  |0->Leaf
  |_->
    let previous_tree = remy(n-1) in
    let k = cpt_node previous_tree in
    step_remy(previous_tree, k)

(* Conversion vers le type commun *)
let rec to_common t =
  match t with
  | Leaf -> Types.Common.Leaf
  | Node (g, d) ->
      let cg = to_common g in
      let cd = to_common d in
      Types.Common.Node (cg, cd)
