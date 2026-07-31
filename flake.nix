{
  description = "Y system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    korb.url = "github:yannick-cw/korb";
    #korb.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [ pkgs.vim ];

        # Nix itself is managed by Determinate (its own daemon), not nix-darwin.
        # This hands off installation management; flakes/nix-command are on by
        # default under Determinate, and gc/trusted-users are configured through
        # Determinate's own config (/etc/nix/nix.custom.conf) instead of here.
        nix.enable = false;

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;
        programs.zsh.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
        nixpkgs.config.allowUnfree = true;

        homebrew = {
          enable = true;
          onActivation.cleanup = "uninstall"; # default: only adds, never removes
          # "uninstall" → removes brew packages NOT in your lists
          # "zap"       → same, plus deletes their config/data files
          casks = [
            "alfred"
            "anki"
            "visual-studio-code"
            "google-drive"
            "whatsapp"
            "karabiner-elements"
            "keycastr"
            "ghostty"
            "firefox"
            "google-chrome"
            "obsidian"
            "steam"
            "little-snitch"
            "postman"
            "signal"
            "sourcetree"
            "spotify"
            "wispr-flow"
            "licecap"
            "calibre"
            "jetbrains-toolbox"
            "zoom"
          ];
        };
        fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

        system.primaryUser = "yannickgladow";

        users.users.yannickgladow = {
          name = "yannickgladow";
          home = "/Users/yannickgladow";
        };

        security.pam.services.sudo_local.touchIdAuth = true;

        system.defaults = {

          dock = {
            autohide = true;
            autohide-delay = 1000.0; # keep it hidden even on hover (intentional)
            orientation = "left";
            mru-spaces = false;
            show-recents = false; # disable recent apps

            # disable all hot corners (1 = no action)
            wvous-tl-corner = 1;
            wvous-tr-corner = 1;
            wvous-bl-corner = 1;
            wvous-br-corner = 1;
          };

          trackpad = {
            Clicking = true;
            Dragging = false;
            TrackpadRightClick = true;
            TrackpadThreeFingerDrag = true;
            FirstClickThreshold = 1;
            SecondClickThreshold = 1;
            TrackpadThreeFingerTapGesture = 0;
          };

          finder = {
            _FXShowPosixPathInTitle = true;
            AppleShowAllExtensions = true;
            ShowPathbar = true;
            ShowStatusBar = true;
          };

          WindowManager.StandardHideWidgets = true;

          NSGlobalDomain = {
            InitialKeyRepeat = 15;
            KeyRepeat = 2;
            ApplePressAndHoldEnabled = false;
            "com.apple.swipescrolldirection" = true; # natural scroll, explicit
            "com.apple.sound.beep.volume" = 0.0;
          };

          CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
            "118" = {
              enabled = true;
              value = {
                type = "standard";
                parameters = [
                  49
                  18
                  524288
                ];
              };
            };
            "119" = {
              enabled = true;
              value = {
                type = "standard";
                parameters = [
                  50
                  19
                  524288
                ];
              };
            };
            "120" = {
              enabled = true;
              value = {
                type = "standard";
                parameters = [
                  51
                  20
                  524288
                ];
              };
            };
            "121" = {
              enabled = true;
              value = {
                type = "standard";
                parameters = [
                  52
                  21
                  524288
                ];
              };
            };
            "122" = {
              enabled = true;
              value = {
                type = "standard";
                parameters = [
                  53
                  23
                  524288
                ];
              };
            };
          };

          CustomUserPreferences.NSGlobalDomain.NSUserKeyEquivalents = {
            "Fill" = "@~^$f";
            "Left" = builtins.fromJSON ''"@~^$\u2190"'';
            "Left & Right" = builtins.fromJSON ''"@~^\u2190"'';
            "Right" = builtins.fromJSON ''"@~^$\u2192"'';
            "Right & Left" = builtins.fromJSON ''"@~^\u2192"'';
          };
        };

        # Hostname unified to y-mac (matches your darwinConfigurations."y-mac")
        networking.computerName = "y-mac";
        networking.hostName = "y-mac";
        networking.localHostName = "y-mac";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro-2
      darwinConfigurations."y-mac" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.yannickgladow = ./home.nix;
            home-manager.backupFileExtension = "hm-bak";
          }
        ];
      };
    };
}
