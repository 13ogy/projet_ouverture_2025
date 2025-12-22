(* src/experiments.ml *)

open Projet_arbres_lib

module RN = Remy_naive
module RL = Remy_lineaire
module AB = Abr
module M = Metrics

(* Création d'un répertoire s'il n'existe pas *)
let ensure_dir dir =
  try
    let st = Unix.stat dir in
    if st.Unix.st_kind = Unix.S_DIR then ()
    else failwith (dir ^ " existe mais n'est pas un répertoire")
  with _ ->
    Unix.mkdir dir 0o755

(* Mesure du temps d'exécution d'une fonction f: retourne (résultat, temps_en_ms) *)
let time f =
  let t0 = Unix.gettimeofday () in
  let x = f () in
  let t1 = Unix.gettimeofday () in
  let dt_ms = (t1 -. t0) *. 1000.0 in
  (x, dt_ms)

(* Écrit l'en-tête du CSV *)
let write_csv_header oc =
  output_string oc "model,n,trial,height,width_internal,avg_leaf_depth,left_subtree_size,internal_count,leaf_count,gen_time_ms\n"

(* Écrit une ligne CSV *)
let write_csv_row oc model n trial h w avg lsize ic lc dt =
  let line =
    Printf.sprintf "%s,%d,%d,%d,%d,%.6f,%d,%d,%d,%.3f\n"
      model n trial h w avg lsize ic lc dt
  in
  output_string oc line

(* Calcul des métriques et écriture d'une ligne CSV pour un arbre commun *)
let metrics_to_csv oc model n trial (common_tree : Types.Common.btree) gen_time_ms =
  let h = M.height common_tree in
  let w = M.width_internal common_tree in
  let avg = M.avg_leaf_depth common_tree in
  let lsize = M.left_subtree_size common_tree in
  let ic = M.internal_count common_tree in
  let lc = M.leaf_count common_tree in
  write_csv_row oc model n trial h w avg lsize ic lc gen_time_ms


let () =
  (* Initialisation aléatoire *)
  Random.self_init ();

  ensure_dir "data";

  (* Ouvre/écrase le CSV de sortie *)
  let oc = open_out "data/experiments.csv" in
  write_csv_header oc;

  (* Tailles d'arbres à tester *)
  let sizes = [10000; 20000; 50000; 100000; 120000; 150000; 175000; 200000] in

  (* Nombre de répétitions par taille *)
  let trials = 10 in

  (* Boucle principale d'expérimentations *)
  let rec loop_sizes ss =
    match ss with
    | [] -> ()
    | n :: q ->
        let rec loop_trials k =
          match k with
          | 0 -> ()
          | t -> (*
              (* Rémy naïf *)
              let (t_rn, dt_rn) = time (fun () -> RN.remy n) in
              let c_rn = RN.to_common t_rn in
              metrics_to_csv oc "remy_naif" n (trials - t + 1) c_rn dt_rn;
              *)
              (* Rémy linéaire *)
              let (t_rl, dt_rl) = time (fun () -> RL.remy n) in
              let c_rl = RL.to_common t_rl in
              metrics_to_csv oc "remy_lineaire" n (trials - t + 1) c_rl dt_rl;

              (* ABR *)
              let (t_ab, dt_ab) = time (fun () -> AB.abr_common n) in
              metrics_to_csv oc "abr" n (trials - t + 1) t_ab dt_ab;

              loop_trials (t - 1)
        in
        loop_trials trials;
        loop_sizes q
  in

  loop_sizes sizes;
  close_out oc;

  print_endline "Experiments completed: data/experiments.csv généré."
