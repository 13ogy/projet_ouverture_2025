(* src/remy_naive.ml *)
open Types.Naive

(* Compte le nombre de nœuds dans l'arbre *)
let rec cpt_node (tree)=
  match tree with
  | Leaf -> 1
  | Node (g,d)->1+cpt_node(g)+cpt_node(d)

(*choisir aleatoirement si le noeud devient fils gauche ou fiche droit d'un nouveau noeud*)
let fils_rand(node)=
  let fils = Random.int 2 in
  match fils with
  |0->Node(node,Leaf)
  |1->Node(Leaf,node)
  |_ -> failwith "Impossible"

(*une tape de l'algorithme de Remy*)
let step_remy (tree,k)=
  (*choix aleatoire d'un noeud parmi les k noeuds de l'arbre*)
  let node_ident = Random.int k in 
  (*on parcourt l'arbre pour trouver le noeud du même index chosi dans le parcours préfixe*)
  let rec choix_cpt(tree,cpt) =
    (*si c'est le bon, on l'étend*)
    if cpt = node_ident then fils_rand(tree),cpt
    else match tree with
      |Leaf->Leaf,cpt
      |Node(g,d)->
          let g2,count = choix_cpt(g,cpt+1) in (*on le cherche à gauche*)
          if g!=g2 then Node(g2,d),count 
          (*si on ne le trouve pas à gauche, on le cherche à droite*)
          else let d2,count_droite = choix_cpt(d,count+1) 
            in Node(g2,d2),count_droite
  in let res,_ = choix_cpt(tree,0) in res

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
