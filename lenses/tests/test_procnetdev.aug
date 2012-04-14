(*
Module: Test_ProcNetDev
  Provides unit tests and examples for the <ProcNetDev> lens.
*)

module Test_ProcNetDev =

(* Variable: dev *)
let dev = "Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
virbr1:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
virbr1-nic:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
    lo: 173055283  291584    0    0    0     0          0         0 173055283  291584    0    0    0     0       0          0
virbr0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 wlan1:    8162      42    0    0    0     0          0         0    12467      71    0    0    0     0       0          0
  eth0: 550305684 1660016    0    0    0     0          0       197 19203308585 14090250    0    0    0     0       0          0
virbr0-nic:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
"
(* Test: ProcNetDev.lns *)
test ProcNetDev.lns get dev =
  { "virbr1"
    { "receive"
      { "bytes" = "0" }
      { "packets" = "0" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "frame" = "0" }
      { "compressed" = "0" }
      { "multicast" = "0" }
    }
    { "transmit"
      { "bytes" = "0" }
      { "packets" = "0" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "colls" = "0" }
      { "carrier" = "0" }
      { "compressed" = "0" }
    }
  }
  { "virbr1-nic"
    { "receive"
      { "bytes" = "0" }
      { "packets" = "0" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "frame" = "0" }
      { "compressed" = "0" }
      { "multicast" = "0" }
    }
    { "transmit"
      { "bytes" = "0" }
      { "packets" = "0" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "colls" = "0" }
      { "carrier" = "0" }
      { "compressed" = "0" }
    }
  }
  { "lo"
    { "receive"
      { "bytes" = "173055283" }
      { "packets" = "291584" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "frame" = "0" }
      { "compressed" = "0" }
      { "multicast" = "0" }
    }
    { "transmit"
      { "bytes" = "173055283" }
      { "packets" = "291584" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "colls" = "0" }
      { "carrier" = "0" }
      { "compressed" = "0" }
    }
  }
  { "virbr0"
    { "receive"
      { "bytes" = "0" }
      { "packets" = "0" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "frame" = "0" }
      { "compressed" = "0" }
      { "multicast" = "0" }
    }
    { "transmit"
      { "bytes" = "0" }
      { "packets" = "0" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "colls" = "0" }
      { "carrier" = "0" }
      { "compressed" = "0" }
    }
  }
  { "wlan1"
    { "receive"
      { "bytes" = "8162" }
      { "packets" = "42" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "frame" = "0" }
      { "compressed" = "0" }
      { "multicast" = "0" }
    }
    { "transmit"
      { "bytes" = "12467" }
      { "packets" = "71" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "colls" = "0" }
      { "carrier" = "0" }
      { "compressed" = "0" }
    }
  }
  { "eth0"
    { "receive"
      { "bytes" = "550305684" }
      { "packets" = "1660016" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "frame" = "0" }
      { "compressed" = "0" }
      { "multicast" = "197" }
    }
    { "transmit"
      { "bytes" = "19203308585" }
      { "packets" = "14090250" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "colls" = "0" }
      { "carrier" = "0" }
      { "compressed" = "0" }
    }
  }
  { "virbr0-nic"
    { "receive"
      { "bytes" = "0" }
      { "packets" = "0" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "frame" = "0" }
      { "compressed" = "0" }
      { "multicast" = "0" }
    }
    { "transmit"
      { "bytes" = "0" }
      { "packets" = "0" }
      { "errs" = "0" }
      { "drop" = "0" }
      { "fifo" = "0" }
      { "colls" = "0" }
      { "carrier" = "0" }
      { "compressed" = "0" }
    }
  }
