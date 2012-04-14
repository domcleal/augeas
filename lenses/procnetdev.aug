(*
Module: ProcNetDev
  Parses /proc/net/dev on Linux.

Author: Dominic Cleal <dcleal@redhat.com>

About: Reference
  This lens is based off the file headings and proc(5).

About: License
  This file is licenced under the LGPL v2+, like the rest of Augeas.

About: Lens Usage
  To be documented

About: Configuration files
  This lens applies to /proc/net/dev
*)

module ProcNetDev =
autoload xfm

(************************************************************************
 * Group:                 USEFUL PRIMITIVES
 *************************************************************************)

(* View: eol *)
let eol = Util.eol

(* View: sep *)
let sep = del /: */ ": "

(* View: indent *)
let indent = Util.del_ws "  "

(* Variable: int *)
let int = Rx.integer

(************************************************************************
 * Group:                 SECTIONS
 *************************************************************************)

(* View: header
   Ignore both lines *)
let header = del /[^\n]+\n/ "Header 1\n" . del /[^\n]+\n/ "Header 2\n"

(* View: interface
   Single line representing an interface *)
let interface = [ Util.del_opt_ws "" . key /[a-z0-9\.-]+/ . Util.del_str ":"
                  . [ label "receive"
                    . [ label "bytes" . indent . store int ]
                    . [ label "packets" . indent . store int ]
                    . [ label "errs" . indent . store int ]
                    . [ label "drop" . indent . store int ]
                    . [ label "fifo" . indent . store int ]
                    . [ label "frame" . indent . store int ]
                    . [ label "compressed" . indent . store int ]
                    . [ label "multicast" . indent . store int ]
                    ]
                  . [ label "transmit"
                    . [ label "bytes" . indent . store int ]
                    . [ label "packets" . indent . store int ]
                    . [ label "errs" . indent . store int ]
                    . [ label "drop" . indent . store int ]
                    . [ label "fifo" . indent . store int ]
                    . [ label "colls" . indent . store int ]
                    . [ label "carrier" . indent . store int ]
                    . [ label "compressed" . indent . store int ]
                    ]
                  . Util.eol ]

(************************************************************************
 * Group:                 LENS
 *************************************************************************)

(* View: lns *)
let lns    = header . interface*

(* View: filter *)
let filter = incl "/proc/net/dev"

let xfm = transform lns filter
