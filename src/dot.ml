open Types.Common

let to_dot t =
  (* Compteurs pour générer des identifiants uniques *)
  let nid = ref 0 in
  let lid = ref 0 in

  (* Génère un nouvel identifiant pour un nœud interne *)
  let fresh_node_id () =
    let i = !nid in
    nid := i + 1;
    "n" ^ string_of_int i
  in

  (* Génère un nouvel identifiant pour une feuille *)
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
        (* Déclaration DOT d’une feuille: shape=point, pas de label *)
        let node_line = name ^ " [shape=point,label=\"\"];"
        in (name, [ node_line ], [])
    | Node (g, d) ->
        let name = fresh_node_id () in
        (* Traiter récursivement le fils gauche puis le fils droit *)
        let (gn, gnodes, gedges) = aux g in
        let (dn, dnodes, dedges) = aux d in
        (* Déclaration DOT d’un nœud interne: shape=circle *)
        let node_line = name ^ " [shape=circle,label=\"\"];" in
        (* Deux arêtes: du parent vers le fils gauche, puis vers le fils droit *)
        let edges = [ name ^ " -> " ^ gn ^ ";"; name ^ " -> " ^ dn ^ ";" ] in
        (* Concaténer la liste des nœuds et la liste des arêtes accumulées *)
        (name, node_line :: (gnodes @ dnodes), edges @ gedges @ dedges)
  in

  (* Lance le parcours depuis la racine *)
  let (_root, nodes, edges) = aux t in

  (* début de la définition de graphe *)
  let header = "digraph G {\n" in
  (* toutes les déclarations de nœuds, chacune sur sa ligne *)
  let body_nodes = String.concat "\n" nodes in
  (* toutes les arêtes, chacune sur sa ligne *)
  let body_edges = String.concat "\n" edges in
  (* fin de la définition de graphe *)
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
