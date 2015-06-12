(* Module: Test_sshd_140 *)
module Test_sshd_140 =

  let accept_env = "Protocol 2
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL\n"

  test Sshd_140.lns get accept_env =
    { "Protocol" = "2" }
    { "AcceptEnv"
        { "1" = "LC_PAPER" }
        { "2" = "LC_NAME" }
        { "3" = "LC_ADDRESS" }
        { "4" = "LC_TELEPHONE" }
        { "5" = "LC_MEASUREMENT" } }
    { "AcceptEnv"
        { "6" = "LC_IDENTIFICATION" }
        { "7" = "LC_ALL" } }


  test Sshd_140.lns get "HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key\n" =
    { "HostKey" = "/etc/ssh/ssh_host_rsa_key" }
    { "HostKey" = "/etc/ssh/ssh_host_dsa_key" }


  test Sshd_140.lns put accept_env after
      rm "AcceptEnv";
      rm "AcceptEnv";
      set "Protocol" "1.5";
      set "X11Forwarding" "yes"
   = "Protocol 1.5\nX11Forwarding yes\n"

  test Sshd_140.lns get "AuthorizedKeysFile  %h/.ssh/authorized_keys\n" =
    { "AuthorizedKeysFile" = "%h/.ssh/authorized_keys" }

  test Sshd_140.lns get "Subsystem sftp /usr/lib/openssh/sftp-server\n" =
    { "Subsystem"
	{ "sftp" = "/usr/lib/openssh/sftp-server" } }

  test Sshd_140.lns get "Subsystem sftp-test /usr/lib/openssh/sftp-server\n" =
    { "Subsystem"
	{ "sftp-test" = "/usr/lib/openssh/sftp-server" } }



  let match_blocks = "X11Forwarding yes
Match User sarko Group pres.*
  Banner /etc/bienvenue.txt
  X11Forwarding no
Match User bush Group pres.* Host white.house.*
Banner /etc/welcome.txt
"
  test Sshd_140.lns get match_blocks =
    { "X11Forwarding" = "yes"}
      { "Match"
	  { "Condition" { "User" = "sarko"   }
	                { "Group" = "pres.*" } }
	  { "Settings"  { "Banner" = "/etc/bienvenue.txt" }
       	                { "X11Forwarding" = "no" } } }
      { "Match"
	  { "Condition" { "User" = "bush"    }
	                { "Group" = "pres.*" }
	                { "Host"  = "white.house.*" } }
	  { "Settings"  { "Banner" = "/etc/welcome.txt" } } }

  test Sshd_140.lns put match_blocks after
    insb "Subsystem" "/Match[1]";
    set "/Subsystem/sftp" "/usr/libexec/openssh/sftp-server"
  = "X11Forwarding yes
Subsystem sftp /usr/libexec/openssh/sftp-server
Match User sarko Group pres.*
  Banner /etc/bienvenue.txt
  X11Forwarding no
Match User bush Group pres.* Host white.house.*
Banner /etc/welcome.txt\n"

(* Test: Sshd_140.lns
   Indent when adding to a Match group *)
  test Sshd_140.lns put match_blocks after
    set "Match[1]/Settings/PermitRootLogin" "yes";
    set "Match[1]/Settings/#comment" "a comment" =
"X11Forwarding yes
Match User sarko Group pres.*
  Banner /etc/bienvenue.txt
  X11Forwarding no
  PermitRootLogin yes
  # a comment
Match User bush Group pres.* Host white.house.*
Banner /etc/welcome.txt\n"


(* Test: Sshd_140.lns
     Parse Ciphers and KexAlgorithms as lists (GH issue #69) *)
test Sshd_140.lns get "Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes128-ctr
KexAlgorithms diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1\n" =
  { "Ciphers"
    { "1" = "aes256-gcm@openssh.com" }
    { "2" = "aes128-gcm@openssh.com" }
    { "3" = "aes256-ctr" }
    { "4" = "aes128-ctr" }
  }
  { "KexAlgorithms"
    { "1" = "diffie-hellman-group-exchange-sha256" }
    { "2" = "diffie-hellman-group14-sha1" }
    { "3" = "diffie-hellman-group-exchange-sha1" }
  }

(* Test: Sshd_140.lns
     Keys are case-insensitive *)
test Sshd_140.lns get "ciPheRs aes256-gcm@openssh.com,aes128-ctr
maTcH User foo
  x11forwarding no\n" =
  { "ciPheRs"
    { "1" = "aes256-gcm@openssh.com" }
    { "2" = "aes128-ctr" }
  }
  { "maTcH"
    { "Condition"
      { "User" = "foo" }
    }
    { "Settings"
      { "x11forwarding" = "no" }
    }
  }

(* Test: Sshd_140.lns
     Allow AllowGroups in Match groups (GH issue #75) *)
test Sshd_140.lns get "Match User foo
AllowGroups users\n" =
  { "Match" { "Condition" { "User" = "foo" } }
    { "Settings" { "AllowGroups" { "1" = "users" } } } }

(* Local Variables: *)
(* mode: caml       *)
(* End:             *)
