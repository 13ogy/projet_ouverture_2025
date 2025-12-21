open Projet_arbres_lib

module RL = Remy_lineaire
module M = Metrics
module D = Dot

(* Création d'un répertoire s'il n'existe pas *)
let ensure_dir dir =
  try
    let st = Unix.stat dir in
    if st.Unix.st_kind = Unix.S_DIR then ()
    else failwith (dir ^ " existe mais n'est pas un répertoire")
  with _ ->
    Unix.mkdir dir 0o755

let () =
  (* Pour des résultats différents à chaque exécution *)
  Random.self_init ();

  let n =
    if Array.length Sys.argv > 1 then
      (try int_of_string Sys.argv.(1) with _ -> 10)
    else 10
  in
  (* Génération de l'arbre (Rémy version linéaire) *)
  let t_lin = RL.remy n in
  let t_common = RL.to_common t_lin in

  (* Calcul et affichage de métriques *)
  let h = M.height t_common in
  let w = M.width_internal t_common in
  let avg = M.avg_leaf_depth t_common in
  let lsize = M.left_subtree_size t_common in
  let ic = M.internal_count t_common in
  let lc = M.leaf_count t_common in

  Printf.printf "Arbre Rémy (linéaire) avec n = %d noeuds internes\n" n;
  Printf.printf "- hauteur = %d\n" h;
  Printf.printf "- largeur (nœuds internes) = %d\n" w;
  Printf.printf "- profondeur moyenne des feuilles = %.4f\n" avg;
  Printf.printf "- taille sous-arbre gauche (nœuds internes) = %d\n" lsize;
  Printf.printf "- nb noeuds internes = %d ; nb feuilles = %d (invariant: feuilles = internes + 1)\n" ic lc;

  (* Export DOT *)
  ensure_dir "graphs";
  let path = Printf.sprintf "graphs/sample_remy_lineaire_n%d.dot" n in
  D.write_dot path t_common;
  Printf.printf "Export DOT: %s\n" path;

  (* Conversion PNG supprimée: utiliser manuellement 'dot -Tpng input.dot -o output.png' si besoin *)

  print_endline "Projet initialisé"
