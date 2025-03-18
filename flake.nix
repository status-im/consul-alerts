{
  description = "Nix flake for consul-alerts.";

  # Locked to provide Go 1.17.13.
  inputs.nixpkgs.url = github:NixOS/nixpkgs/8fb01fab4f38dbcf6e5e55a786aef0d77fe28865;

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux" "i686-linux" "aarch64-linux"
        "x86_64-darwin" "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in rec {
      devShells = forAllSystems (system: let
        pkgs = pkgsFor.${system};
      in {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [ go_1_17 ];
        };
      });
  };
}
