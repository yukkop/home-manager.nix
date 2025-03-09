{
  description = "Home Manager configuration via flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    yukkpkgs = {
      url = "github:yukkop/yukkop.nix/new-dev";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        util.follows = "util";
        nixvim.follows = "nixvim";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    util = {
      url = "github:hectic-lab/util.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, util, yukkpkgs, nixvim, ... }:
    util.lib.forAllSystemsWithPkgs [] ({ system, pkgs, }: {
      homeConfigurations = {
        default.${system} = self.homeConfigurations.yukkop.${system};
        yukkop.${system} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            nixvim.homeManagerModules.nixvim 
            {
              #programs = {
	      #  nixvim = yukkpkgs.config.nixvim;
              #  zsh = yukkpkgs.config.zsh;
              #};

              home = {
                # impermanence
                #home.persistence."/persist/home/${user}" = 
                # lib.mkIf config.preset.impermanence
                #{
                #  directories = [
                #    "$XDG_DATA_HOME/nvim/treesitter"
                #  ];
                #  allowOther = true;
                #};

	        username = "yukkop";
                homeDirectory = "/home/yukkop";
                stateVersion = "24.11";
                packages = with pkgs; [ 
                  git
                  yq-go
                  jq
                  entr
                  postgresql_15
                ];
	      };
            }
          ];
        };
      };
    });
}
