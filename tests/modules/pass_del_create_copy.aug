(* Test that the del lens will copy previous deleted strings (if available) and
   use them when creating new nodes, rather than using the string given *)
module Pass_del_create_copy =

  let indent = del /[ \t]*/ "  "
  let lns = [ indent . label "entry" . store /[^ \t\n]+/ . del "\n" "\n" ]*

  test lns get "a\n b\n  c\n" =
    { "entry" = "a" }
    { "entry" = "b" }
    { "entry" = "c" }

  (* 'c' should copy indent from 'b' *)
  test lns put "a\n b\n" after
    set "entry[3]" "c"
  = "a\n b\n c\n"

  (* 'c' should use the string in the del lens *)
  (* When using lns, it's "putting" 'c', 'a' and creating 'b' as they share
     the same keys.  This test uses different keys. *)
  let keytest = [ indent . key /[a-z]+/ . del "\n" "\n" ]*
  test keytest put "a\n b\n" after
    insb "c" "a"
  = "  c\na\n b\n"

