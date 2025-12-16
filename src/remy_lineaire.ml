open Types.Lineaire

let fils_rand(node)=
  let fils = Random.int 2 in
  match fils with
  |0->Node(node,Leaf)
  |1->Node(Leaf,node)
  |_ -> failwith "Impossible"

let step_remy (tree)= 
  match tree.root with


let remy(n)=
  match n with
  |0->let new_tree = {root = Some (ref Leaf); nodes = [||]; size = 1} in
    new_tree
  |_->let previous_tree = remy(n-1) in
    step_remy(previous_tree)