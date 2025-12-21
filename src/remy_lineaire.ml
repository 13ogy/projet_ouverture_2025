open Types.Lineaire


let fils_rand(node)=
  let leaf_ref = ref Leaf in
  let node_ref = ref node in
  
  let fils = Random.int 2 in
  match fils with
  |0->(Node(node_ref,leaf_ref)),leaf_ref,node_ref
  |1->(Node(leaf_ref,node_ref)),leaf_ref,node_ref
  |_ -> failwith "Impossible"

let step_remy (tree)= 
  let chosen_index = Random.int tree.size in
  let chosen_node = tree.nodes.(chosen_index) in (*noeud choisi aléatoirement*)
                                                 
  let old_node = !(chosen_node) in 
                                                 
  let new_node,new_leaf,old_node_ref = fils_rand(old_node) in
  
  chosen_node := new_node;
  
  tree.nodes.(tree.size)<-old_node_ref;
  tree.nodes.(tree.size+1)<-new_leaf;
  tree.size<-tree.size+2;
  tree


let create_tree (n)=
  let racine= ref Leaf in
  {
    nodes=Array.make (2*n+1) racine;
    size=1;
  }
let remy(n)=
  let tree = create_tree n in
  let rec remy_rec(aux) =
    match aux with
    |0->tree
    |_-> let _= step_remy tree in remy_rec(aux-1)
  in remy_rec n
    
(* Conversion vers le type commun *)
let to_common (tree) =
  (* On part de la racine ( en pos 0 ) *)
  let noeud = tree.nodes.(0) in
  let rec aux node =
    match !node with
    | Leaf -> Types.Common.Leaf
    | Node (g, d) -> Types.Common.Node (aux g, aux d)
  in
  aux noeud
