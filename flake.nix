{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      app = pkgs.buildGoModule {
        pname = "app";
        version = "0.0.1";
        src = ./.;
        vendorHash = null;
      };
    in
    {
      packages.${system}.app = pkgs.dockerTools.buildImage {
        name = "helix-plugins";
        tag = "prod";
        created = "now";
        copyToRoot = pkgs.buildEnv {
          name = "image-root";
          paths = [ app ];
          pathsToLink = [ "/bin" ];
        };
        config = {
          Cmd = [ "${app}/bin/app" ];
          ExposedPorts = {
            "8080/tcp" = { };
          };
        };
      };
    };
}
