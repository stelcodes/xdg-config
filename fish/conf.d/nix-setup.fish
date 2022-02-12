if not [ $NIX_SETUP_COMPLETE ] && [ -n $HOME ] && [ -n $USER ] && [ -e ~/.nix-profile ]

  # To install single user Nix:
  # curl -L https://nixos.org/nix/install --output nix-install.sh
  # chmod +x nix-install.sh
  # ./nix-install.sh --no-daemon

  # Set up the per-user profile.
  # This part should be kept in sync with nixpkgs:nixos/modules/programs/shell.nix

  set -l NIX_LINK $HOME/.nix-profile

  # Set up environment.
  # This part should be kept in sync with nixpkgs:nixos/modules/programs/environment.nix
  set -x NIX_PROFILES "/nix/var/nix/profiles/default $HOME/.nix-profile"

  # Set $NIX_SSL_CERT_FILE so that Nixpkgs applications like curl work.
  if [ -e /etc/ssl/certs/ca-certificates.crt ] # NixOS, Ubuntu, Debian, Gentoo, Arch
    set -x NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
  else if [ -e /etc/ssl/ca-bundle.pem ] # openSUSE Tumbleweed
    set -x NIX_SSL_CERT_FILE /etc/ssl/ca-bundle.pem
  else if [ -e /etc/ssl/certs/ca-bundle.crt ] # Old NixOS
    set -x NIX_SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
  else if [ -e /etc/pki/tls/certs/ca-bundle.crt ] # Fedora, CentOS
    set -x NIX_SSL_CERT_FILE /etc/pki/tls/certs/ca-bundle.crt
  else if [ -e "$NIX_LINK/etc/ssl/certs/ca-bundle.crt" ] # fall back to cacert in Nix profile
    set -x NIX_SSL_CERT_FILE "$NIX_LINK/etc/ssl/certs/ca-bundle.crt"
  else if [ -e "$NIX_LINK/etc/ca-bundle.crt" ] # old cacert in Nix profile
    set -x NIX_SSL_CERT_FILE "$NIX_LINK/etc/ca-bundle.crt"
  end

  # Possibly not needed because manpath seems to work without this
  # if [ -n "${MANPATH-}" ]
  #     set -x MANPATH="$NIX_LINK/share/man:$MANPATH"
  # end

  set -x NIXPKGS_ALLOW_UNFREE 1

  fish_add_path "$NIX_LINK/bin"

  set -x NIX_SETUP_COMPLETE 1
end
