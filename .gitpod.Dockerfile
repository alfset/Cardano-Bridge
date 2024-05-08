FROM nixos/nix:latest

# Install necessary tools
RUN nix-channel --update
RUN nix-env -iA nixpkgs.git nixpkgs.cabal-install nixpkgs.haskellPackages.ghc

# Setup Plutus repository
RUN git clone https://github.com/input-output-hk/plutus.git /home/gitpod/plutus
WORKDIR /home/gitpod/plutus

# Enter nix-shell, pre-build steps
RUN nix-shell
