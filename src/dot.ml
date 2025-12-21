(* src/dot.ml *)
open Types.Common

let to_dot t =
  let nid = ref 0 in
  let lid = ref 0 in

  let fresh_node_id () =
    let i = !nid in
    nid := i + 1;
    "n" ^ string_of_int i
  in
  let fresh_leaf_id () =
    let i = !lid in
    lid := i + 1;
    "l" ^ string_of_int i
  in

  (* Retourne: (nom_du_noeud_racine, liste_descr_noeuds, liste_descr_aretes) *)
  let rec aux arbre =
    match arbre with
    | Leaf ->
        let name = fresh_leaf_id () in
        let node_line = name ^ " [shape=point,label=\"\"];"
        in (name, [ node_line ], [])
    | Node (g, d) ->
        let name = fresh_node_id () in
        let (gn, gnodes, gedges) = aux g in
        let (dn, dnodes, dedges) = aux d in
        let node_line = name ^ " [shape=circle,label=\"\"];" in
        let edges = [ name ^ " -> " ^ gn ^ ";"; name ^ " -> " ^ dn ^ ";" ] in
        (name, node_line :: (gnodes @ dnodes), edges @ gedges @ dedges)
  in

  let (_root, nodes, edges) = aux t in
  let header = "digraph G {\n" in
  let body_nodes = String.concat "\n" nodes in
  let body_edges = String.concat "\n" edges in
  let footer = "\n}\n" in
  header ^ body_nodes ^ "\n" ^ body_edges ^ footer

(* Écrit une chaîne dans un fichier [path]. *)
let write_string_to_file path content =
  let oc = open_out path in
  output_string oc content;
  close_out oc

(* Fonction utilitaire: export direct d'un arbre vers un fichier .dot *)
let write_dot path t =
  let dot = to_dot t in
  write_string_to_file path dot
