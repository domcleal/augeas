module Test_device_map =

  let conf = "# this device map was generated by anaconda
(fd0)     /dev/fda
(hd0)     /dev/sda
(cd0)     /dev/cdrom
(hd1,1)   /dev/sdb1
(hd0,a)   /dev/sda1
(0x80)    /dev/sda
(128)     /dev/sda
"

  test Device_map.lns get conf =
    { "#comment" = "this device map was generated by anaconda" }
    { "fd0" = "/dev/fda" }
    { "hd0" = "/dev/sda" }
    { "cd0" = "/dev/cdrom" }
    { "hd1,1" = "/dev/sdb1" }
    { "hd0,a" = "/dev/sda1" }
    { "0x80"  = "/dev/sda" }
    { "128"   = "/dev/sda" }

  test Device_map.lns put conf after
    set "hd2,1" "/dev/sdb1"
  = "# this device map was generated by anaconda
(fd0)     /dev/fda
(hd0)     /dev/sda
(cd0)     /dev/cdrom
(hd1,1)   /dev/sdb1
(hd0,a)   /dev/sda1
(0x80)    /dev/sda
(128)     /dev/sda
(hd2,1)     /dev/sdb1
"
