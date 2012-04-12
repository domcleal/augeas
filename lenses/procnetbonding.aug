(*
Module: ProcNetBonding
  Parses /proc/net/bonding/* status files on Linux.

Author: Dominic Cleal <dcleal@redhat.com>

About: Reference
  This lens is based off Documentation/net/bonding.txt and various examples.

About: License
  This file is licenced under the LGPL v2+, like the rest of Augeas.

About: Lens Usage
  To be documented

About: Configuration files
  This lens applies to /proc/net/bonding/* (see <filter>).
*)

module ProcNetBonding =
autoload xfm

(************************************************************************
 * Group:                 USEFUL PRIMITIVES
 *************************************************************************)

(* View: eol *)
let eol = Util.eol

(* View: sep *)
let sep = del /: */ ": "

(* Variable: to_eol *)
let to_eol = /([^ \t\n][^\n]*[^ \t\n]|[^ \t\n])/

(* Variable: version *)
let version = /[0-9\.]+/

(* View: kv_line *)
let kv_line (kw:string) (lbl:string) (val:lens) =
    [ label lbl . Util.del_opt_ws "" . Util.del_str kw . sep . val ]

(* View: simple_line *)
let simple_line (kw:string) (lbl:string) =
    kv_line kw lbl ( store to_eol . eol )

(************************************************************************
 * Group:                 SECTIONS
 *************************************************************************)

(* View: header
   Driver version information *)
let header =
     let date = [ Util.del_str " (" . label "date"
                  . store /[^\)]+/ .  Util.del_str ")" ]
  in [ Util.del_str "Ethernet Channel Bonding Driver: " . label "driver"
       . del /v?/ "" . store version . date . eol+ ]

(* View: sec_mode
   Bonding mode overview *)
let sec_mode =
     let xmit_policy = store /[^ ]+/ . Util.del_str " (" . [ label "id"
                       . store Rx.integer ] . Util.del_str ")" . eol
  in let arp_target  = [ seq "arp" . store Rx.ipv4 ]
  in let arp_targets = counter "arp" . Build.opt_list arp_target
                         ( Util.del_str ", " ) . eol
  in ( simple_line "Bonding Mode" "mode"
       | kv_line "Transmit Hash Policy" "xmit_hash_policy" xmit_policy
       | simple_line "MII Status" "mii_status" 
       | simple_line "MII Polling Interval (ms)" "mii_interval" 
       | simple_line "Up Delay (ms)" "up_delay" 
       | simple_line "Down Delay (ms)" "down_delay" 
       | simple_line "Primary Slave" "primary_slave" 
       | simple_line "Currently Active Slave" "active_slave" 
       | kv_line "ARP IP target/s (n.n.n.n form)" "arp_ip_targets" arp_targets
       | simple_line "ARP Polling Interval (ms)" "arp_interval" )+ . eol+

(* View: sec_8023ad
   Optional section with 802.3ad aggregation info*)
let sec_8023ad =
     let active_lines =
       ( simple_line "Aggregator ID" "aggregator_id"
         | simple_line "Number of ports" "ports"
         | simple_line "Actor Key" "actor_key"
         | simple_line "Partner Key" "partner_key"
         | simple_line "Partner Mac Address" "partner_mac" )+
  in let lines =
       ( simple_line "LACP rate" "lacp_rate" 
         | kv_line "Active Aggregator Info" "active_aggregator"
             ( Util.del_str "\n" . active_lines ) )
  in [ key "802.3ad" . Util.del_str " info\n" . lines+ . eol+ ]

(* View: sec_slave
   Repeated section with individual slave/interface info *)
let sec_slave =
     let lines =
       ( simple_line "MII Status" "mii_status" 
         | simple_line "Link Failure Count" "link_failures" 
         | simple_line "Permanent HW addr" "permanent_mac"
         | simple_line "Aggregator ID" "aggregator_id" )
  in let slave = store to_eol . eol . lines+
  in ( kv_line "Slave Interface" "slave" slave ) . eol*

(************************************************************************
 * Group:                 LENS
 *************************************************************************)

(* View: lns *)
let lns    = header . sec_mode . sec_8023ad? . sec_slave+

(* View: filter *)
let filter = incl "/proc/net/bonding/*"

let xfm = transform lns filter
