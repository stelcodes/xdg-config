function log-packages
  set dnf_packages = ""
  if test (command -v dnf)
    set dnf_packages "DNF PACKAGES\n$(dnf history)\n"
  end

  set nix_packages = ""
  if test (command -v nix-env)
    set nix_packages "NIX PACKAGES\n$(nix-env -q)\n"
  end

  echo -e "$(date -u +"%Y-%m-%dT%H:%M:%SZ")\n\n$dnf_packages\n$nix_packages" | tee "$HOME/.packages-log"
end
