(*
Module: Hosts_Access
  Parses /etc/hosts.{allow,deny}

Author: Raphael Pinson <raphink@gmail.com>

About: Reference
  This lens tries to keep as close as possible to `man 5 hosts_access` where possible.

About: License
   This file is licenced under the LGPLv2+, like the rest of Augeas.

About: Lens Usage
   To be documented

About: Configuration files
   This lens applies to /etc/hosts.{allow,deny}. See <filter>.
*)

module Hosts_Access =

autoload xfm

(************************************************************************
 * Group:                 USEFUL PRIMITIVES
 *************************************************************************)

(* View: colon *)
let colon = del /[ \t]*:[ \t]*/ ": "

(* Variable: comma_sep *)
let comma_sep = /([ \t]|(\\\\\n))*,([ \t]|(\\\\\n))*/

(* Variable: ws_sep *)
let ws_sep = / +/

(* View: list_sep *)
let list_sep = del ( comma_sep | ws_sep ) ", "

(* View: list_item *)
let list_item = store ( Rx.word - /EXCEPT/i )

(* View: sto_to_eol *)
let sto_to_eol = store /[^ \t\n:][^\n]*[^ \t\n]|[^ \t\n:]/

(* View: except
 * The except operator makes it possible to write very compact rules.
 *)
let except (lns:lens) = [ label "except" . Sep.space
                        . del /except/i "EXCEPT"
                        . Sep.space . lns ]

(************************************************************************
 * Group:                 ENTRY TYPES
 *************************************************************************)

(* View: daemon *)
let daemon =
  let host = [ label "host"
             . Util.del_str "@"
             . list_item ] in
   [ label "process"
   . list_item
   . host? ]

(* View: daemon_list
    A list of <daemon>s *)
let daemon_list = Build.opt_list daemon list_sep

(* View: client *)
let client =
  let user = [ label "user"
             . list_item
             . Util.del_str "@" ] in
    [ label "client"
    . user?
    . list_item ]

(* View: client_list
    A list of <client>s *)
let client_list = Build.opt_list client list_sep

(* View: shell_command *)
let shell_command = [ label "shell_command"
                    . sto_to_eol ]

(* View: entry *)
let entry = [ seq "line"
            . daemon_list
            . (except daemon_list)?
            . colon
            . client_list
            . (except client_list)?
            . (colon . shell_command)?
            . Util.eol ]

(************************************************************************
 * Group:                 LENS AND FILTER
 *************************************************************************)

(* View: lns *)
let lns = (Util.empty | Util.comment | entry)*

(* View: filter *)
let filter = incl "/etc/hosts.allow"
           . incl "/etc/hosts.deny"

let xfm = transform lns filter
