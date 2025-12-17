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
  
type btree =
  | Leaf
  | Node of  btree_ref * btree_ref 
and btree_ref = btree ref


type tree= {
  nodes : btree_ref array ;
  mutable size : int ;
}
end