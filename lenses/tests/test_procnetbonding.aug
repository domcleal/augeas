(*
Module: Test_ProcNetBonding
  Provides unit tests and examples for the <ProcNetBonding> lens.
*)

module Test_ProcNetBonding =

(* Variable: bondingtxt *)
let bondingtxt = "Ethernet Channel Bonding Driver: 2.6.1 (October 29, 2004)
Bonding Mode: load balancing (round-robin)
Currently Active Slave: eth0
MII Status: up
MII Polling Interval (ms): 1000
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: eth1
MII Status: up
Link Failure Count: 1

Slave Interface: eth0
MII Status: up
Link Failure Count: 1
"
(* Test: ProcNetBonding.lns *)
test ProcNetBonding.lns get bondingtxt =
  { "driver" = "2.6.1"
    { "date" = "October 29, 2004" } }
  { "mode" = "load balancing (round-robin)" }
  { "active_slave" = "eth0" }
  { "mii_status" = "up" }
  { "mii_interval" = "1000" }
  { "up_delay" = "0" }
  { "down_delay" = "0" }
  { "slave" = "eth1"
    { "mii_status" = "up" }
    { "link_failures" = "1" } }
  { "slave" = "eth0"
    { "mii_status" = "up" }
    { "link_failures" = "1" } }

(* Variable: activebackup *)
let activebackup = "Ethernet Channel Bonding Driver: v3.4.0 (October 7, 2008)

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: None
Currently Active Slave: eth1
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
ARP Polling Interval (ms): 1000
ARP IP target/s (n.n.n.n form): 169.254.144.20, 169.254.144.21

Slave Interface: eth0
MII Status: up
Link Failure Count: 1
Permanent HW addr: 00:21:9b:a4:49:65

Slave Interface: eth1
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:21:9b:a4:49:67
"
(* Test: ProcNetBonding.lns *)
test ProcNetBonding.lns get activebackup =
  { "driver" = "3.4.0"
    { "date" = "October 7, 2008" } }
  { "mode" = "fault-tolerance (active-backup)" }
  { "primary_slave" = "None" }
  { "active_slave" = "eth1" }
  { "mii_status" = "up" }
  { "mii_interval" = "100" }
  { "up_delay" = "0" }
  { "down_delay" = "0" }
  { "arp_interval" = "1000" }
  { "arp_ip_targets"
    { "1" = "169.254.144.20" }
    { "2" = "169.254.144.21" } }
  { "slave" = "eth0"
    { "mii_status" = "up" }
    { "link_failures" = "1" }
    { "permanent_mac" = "00:21:9b:a4:49:65" } }
  { "slave" = "eth1"
    { "mii_status" = "up" }
    { "link_failures" = "0" }
    { "permanent_mac" = "00:21:9b:a4:49:67" } }

(* Variable: aggregation *)
let aggregation = "Ethernet Channel Bonding Driver: v3.4.0 (October 7, 2008)

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer2+3 (2)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

802.3ad info
LACP rate: slow
Active Aggregator Info:
        Aggregator ID: 3
        Number of ports: 2
        Actor Key: 17
        Partner Key: 16385
        Partner Mac Address: 00:22:67:00:11:22

Slave Interface: eth0
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:15:17:00:11:22
Aggregator ID: 2

Slave Interface: eth1
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:15:17:00:11:22
Aggregator ID: 2

Slave Interface: eth2
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:30:48:00:11:22
Aggregator ID: 3

Slave Interface: eth3
MII Status: up
Link Failure Count: 0
Permanent HW addr: 00:30:48:00:11:22
Aggregator ID: 3
"
(* Test: ProcNetBonding.lns *)
test ProcNetBonding.lns get aggregation =
  { "driver" = "3.4.0"
    { "date" = "October 7, 2008" } }
  { "mode" = "IEEE 802.3ad Dynamic link aggregation" }
  { "xmit_hash_policy" = "layer2+3"
    { "id" = "2" } }
  { "mii_status" = "up" }
  { "mii_interval" = "100" }
  { "up_delay" = "0" }
  { "down_delay" = "0" }
  { "802.3ad"
    { "lacp_rate" = "slow" }
    { "active_aggregator"
      { "aggregator_id" = "3" }
      { "ports" = "2" }
      { "actor_key" = "17" }
      { "partner_key" = "16385" }
      { "partner_mac" = "00:22:67:00:11:22" } } }
  { "slave" = "eth0"
    { "mii_status" = "up" }
    { "link_failures" = "0" }
    { "permanent_mac" = "00:15:17:00:11:22" }
    { "aggregator_id" = "2" } }
  { "slave" = "eth1"
    { "mii_status" = "up" }
    { "link_failures" = "0" }
    { "permanent_mac" = "00:15:17:00:11:22" }
    { "aggregator_id" = "2" } }
  { "slave" = "eth2"
    { "mii_status" = "up" }
    { "link_failures" = "0" }
    { "permanent_mac" = "00:30:48:00:11:22" }
    { "aggregator_id" = "3" } }
  { "slave" = "eth3"
    { "mii_status" = "up" }
    { "link_failures" = "0" }
    { "permanent_mac" = "00:30:48:00:11:22" }
    { "aggregator_id" = "3" } }
