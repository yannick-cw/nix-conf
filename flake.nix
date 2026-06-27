{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ pkgs.vim ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      nix.settings.trusted-users = [ "yannickgladow" ];

      nix.optimise.automatic = true;          # dedupe store via hardlinks
      nix.gc = {
        automatic = true;
        interval = { Weekday = 0; Hour = 3; Minute = 0; };  # weekly, Sun 3am
        options = "--delete-older-than 30d";
      };

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
        onActivation.cleanup = "none";   # default: only adds, never removes
        # "uninstall" → removes brew packages NOT in your lists
        # "zap"       → same, plus deletes their config/data files
        casks = [
          "alfred" "anki" "visual-studio-code" "whatsapp" "karabiner-elements" "keycastr"
          "iterm2" # — drop once on Ghostty setup
          "ghostty" "firefox" "google-chrome" "obsidian" "steam"
          "little-snitch" "postman" "signal" "sourcetree" "spotify"
          "wispr-flow" "calibre"
        ];
      };
      fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

      system.primaryUser = "yannickgladow";

      security.pam.services.sudo_local.touchIdAuth = true;

      system.defaults.dock = {
        autohide = true;
        autohide-delay = 1000.0;   # keep it hidden even on hover (intentional)
        orientation = "left";
        mru-spaces = false;
      };

      system.defaults.trackpad = {
        Clicking = true;
        Dragging = false;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        FirstClickThreshold = 1;
        SecondClickThreshold = 1;
        TrackpadThreeFingerTapGesture = 0;
      };

      system.defaults.NSGlobalDomain = {
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        ApplePressAndHoldEnabled = false;
        "com.apple.swipescrolldirection" = true;   # natural scroll, explicit
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
