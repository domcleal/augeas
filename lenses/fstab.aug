(* Parsing /etc/fstab *)

module Fstab =
  autoload xfm

  let sep_tab = Sep.tab
  let sep_spc = Sep.space
  let comma   = Sep.comma
  let eol     = Util.eol

  let comment = Util.comment
  let empty   = Util.empty

  let word    = Rx.word - /"/
  let spec    = /[^,# \n\t][^ \n\t]*/
  let quoted  = /[^"\n]*/
  let quoted_opt_val = Util.del_str "\"" . store word . Util.del_str "\""

  let opt_val = store word | quoted_opt_val

  let comma_sep_list (l:string) =
    let value = [ label "value" . Util.del_str "=" . opt_val ] in
      let lns = [ label l . store word . value? ] in
         Build.opt_list lns comma

  let record = [ seq "mntent" .
                   [ label "spec" . store spec ] . sep_tab .
                   [ label "file" . store Rx.neg1 ] . sep_tab .
                   comma_sep_list "vfstype" . sep_tab .
                   comma_sep_list "opt" .
                   (sep_tab . [ label "dump" . store /[0-9]+/ ] .
                    ( sep_spc . [ label "passno" . store /[0-9]+/ ])? )?
                 . eol ]

  let lns = ( empty | comment | record ) *
  let filter = (incl "/etc/fstab")
             . (incl "/etc/mtab")

  let xfm = transform lns filter

(* Local Variables: *)
(* mode: caml *)
(* End: *)
