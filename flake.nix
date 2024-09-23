{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";


    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

  };

  outputs = inputs: 

  let 
    system = "x86_64-linux";
    lib = inputs.nixpkgs.lib;
    specialArgs = { inherit inputs; };
  in {
    nixosConfigurations = {
      spas = lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix

          inputs.home-manager.nixosModules.home-manager {
            nixpkgs.overlays = [
              inputs.neorg-overlay.overlays.default
            ];
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages =true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.spas = {
              imports = [
              ./home-manager/home.nix
              inputs.nixvim.homeManagerModules.nixvim
              ];
            };
          }
        ];
      };
    };
  };
}
