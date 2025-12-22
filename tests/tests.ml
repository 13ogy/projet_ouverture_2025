open Projet_arbres_lib

module RN = Remy_naive
module RL = Remy_lineaire
module AB = Abr
module M = Metrics

(* Trouve la racine du projet en remontant les répertoires jusqu'à trouver "dune-project". *)
let rec find_repo_root dir =
  let marker = Filename.concat dir "dune-project" in
  if Sys.file_exists marker then dir
  else
    let parent = Filename.dirname dir in
    if parent = dir then dir else find_repo_root parent

(* Création d'un répertoire s'il n'existe pas *)
let ensure_dir path =
  try
    let st = Unix.stat path in
    if st.Unix.st_kind = Unix.S_DIR then ()
    else failwith (path ^ " existe mais n'est pas un répertoire")
  with _ ->
    Unix.mkdir path 0o755

(* Fonction auxilierre pour calculer le temps d'exécution *)
let time f =
  let t0 = Unix.gettimeofday () in
  let x = f () in
  let t1 = Unix.gettimeofday () in
  let dt_ms = (t1 -. t0) *. 1000.0 in
  (x, dt_ms)

let write_csv_header oc =
  output_string oc "model,n,height,width_internal,avg_leaf_depth,left_subtree_size,internal_count,leaf_count,gen_time_ms\n"

(* Fonction auxilierre pour l'écriture des statistiques *)
let write_row oc model n h w avg lsize ic lc dt_ms =
  let line =
    Printf.sprintf "%s,%d,%d,%d,%.6f,%d,%d,%d,%.3f\n"
      model n h w avg lsize ic lc dt_ms
  in
  output_string oc line

let () =
  (* RNG déterministe pour les tests *)
  Random.init 42;

  let cwd = Sys.getcwd () in
  let root = find_repo_root cwd in
  let data_dir = Filename.concat root "data" in
  ensure_dir data_dir;
  let stats_path = Filename.concat data_dir "stats.csv" in

  let oc = open_out stats_path in
  write_csv_header oc;

  (* Tailles testées *)
  let sizes = [ 10; 50; 100; 200; 500; 1000; 1500 ] in

  let rec loop_sizes ss =
    match ss with
    | [] -> ()
    | n :: q ->
        (* Rémy naïf *)
        let (t_rn, dt_rn) = time (fun () -> RN.remy n) in
        let c_rn = RN.to_common t_rn in
        let h_rn = M.height c_rn in
        let w_rn = M.width_internal c_rn in
        let avg_rn = M.avg_leaf_depth c_rn in
        let lsize_rn = M.left_subtree_size c_rn in
        let ic_rn = M.internal_count c_rn in
        let lc_rn = M.leaf_count c_rn in
        write_row oc "remy_naif" n h_rn w_rn avg_rn lsize_rn ic_rn lc_rn dt_rn;

        (* Rémy linéaire *)
        let (t_rl, dt_rl) = time (fun () -> RL.remy n) in
        let c_rl = RL.to_common t_rl in
        let h_rl = M.height c_rl in
        let w_rl = M.width_internal c_rl in
        let avg_rl = M.avg_leaf_depth c_rl in
        let lsize_rl = M.left_subtree_size c_rl in
        let ic_rl = M.internal_count c_rl in
        let lc_rl = M.leaf_count c_rl in
        write_row oc "remy_lineaire" n h_rl w_rl avg_rl lsize_rl ic_rl lc_rl dt_rl;

        (* ABR *)
        let (c_ab, dt_ab) = time (fun () -> AB.abr_common n) in
        let h_ab = M.height c_ab in
        let w_ab = M.width_internal c_ab in
        let avg_ab = M.avg_leaf_depth c_ab in
        let lsize_ab = M.left_subtree_size c_ab in
        let ic_ab = M.internal_count c_ab in
        let lc_ab = M.leaf_count c_ab in
        write_row oc "abr" n h_ab w_ab avg_ab lsize_ab ic_ab lc_ab dt_ab;

        loop_sizes q
  in

  loop_sizes sizes;
  close_out oc;

  Printf.printf "Tests terminés: statistiques écrites dans %s\n" stats_path
