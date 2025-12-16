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

type 'a node = {
  value : 'a btree ref ;
  mutable index : int ;
  parent : 'a node option ;
}

type 'a tree= {
  mutable root : 'a btree ref option ;
  mutable nodes : 'a node array ;
  mutable size : int ;
}
end