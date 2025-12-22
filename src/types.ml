module Common = struct
  type btree =
  | Leaf
  | Node of btree * btree
end

module Naive = struct
  type 'a btree =
  | Leaf
  | Node of 'a btree * 'a btree
end

module Lineaire = struct
  type btree =
  | Leaf
  | Node of btree_ref * btree_ref
  and btree_ref = btree ref

  type tree = {
    nodes : btree_ref array;  (* tableau de références vers les nœuds à choisir *)
    mutable size : int;       (* nombre d'entrées actuellement actives *)
  }
end
