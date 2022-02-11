function vpn
  if count $argv &> /dev/null
    protonvpn-cli $argv
  else
    protonvpn-cli netshield --ads-malware
    protonvpn-cli killswitch --on
    protonvpn-cli config --protocol udp --dns automatic --vpn-accelerator
    protonvpn-cli connect --sc
  end
end
