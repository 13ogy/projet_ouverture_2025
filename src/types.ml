(* src/types.ml *)

module Naive = struct
  (* type simple pour l'algorithme naïf *) 

  type 'a btree =
  | Leaf
  | Node of 'a btree * 'a btree
end

module Lineaire = struct
  (* nouvelle structure de données, 
  on garde une array pour stocker toutes les reférences aux noeuds*)
  
  type 'a btree =
  | Leaf
  | Node of 'a btree * 'a btree
and 'a btree_ref = 'a btree ref

type 'a node = {
  value : 'a btree_ref ;
  mutable index : int ;
}

type 'a liste_node = {
  mutable nodes : 'a node array ;
  mutable size : int ;
}
end