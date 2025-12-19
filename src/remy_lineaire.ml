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
    
  
(*test*)

type btree_normal =
  |LeafB
  |NodeB of btree_normal * btree_normal
    
let tree_to_btree(tree)=
  let noeud = tree.nodes.(0) in
  let rec aux (node)=
    match !node with
    |Leaf -> LeafB 
    |Node (g,d)->NodeB(aux g, aux d)
  in aux noeud
  
  
let rec profondeur(btree) =
  match btree with
  |LeafB->0
  |NodeB(g,d)-> 1+max (profondeur g) (profondeur d)
                  
                  
let profondeur_list(btree)=
  let rec aux k tree=
    match tree with
    |LeafB->[k]
    |NodeB(g,d)-> (aux (k+1) g ) @ (aux (k+1) d) 
  in aux 0 btree
  
    
    
let profondeur_mean(btree)=
  let l=profondeur_list(btree)in
  let sum = List.fold_left (fun acc x -> acc +. float_of_int x) 0.0 l in
  sum /. float_of_int (List.length l)
    
    
let rec nb_noeud_etage(btree,etage)=
  match etage with
  |0 -> 1
  |_-> match btree with
    |LeafB->0
    |NodeB(g,d)->nb_noeud_etage(g,etage-1)+nb_noeud_etage(d,etage-1) 
  
let rec range n =
  match n with
  |0->[0]
  |n-> n::range (n-1)
     
let rec maxL list =
  match list with
  |[]->failwith "empty list"
  | h :: t -> List.fold_left max h t
                 
  
let largeur (btree)=
  let k=range (profondeur btree) in
  let etages=List.map (fun x ->nb_noeud_etage(btree,x)) k in
  maxL etages
  
  
let rec taille_gauche(btree)=
  match btree with 
  |LeafB -> 0
  |NodeB(g,_)->taille_gauche(g)+1
  
let test(tree)=
  let btree= tree_to_btree(tree) in btree,taille_gauche(btree)
  
let remy10=tree_to_btree(remy 10)
