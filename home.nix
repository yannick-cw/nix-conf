{ pkgs, inputs, ... }:
{
  # merges all these modules to be configured here
  imports = [
    ./ghostty.nix
    ./zsh.nix
    ./git.nix
    ./neovim.nix
    inputs.nix-index-database.homeModules.nix-index
  ];
  home = {
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      KORB_CURL = "curl_safari184_ios";
      JAVA_HOME = "${pkgs.jdk21}/zulu-21.jdk/Contents/Home";
    };
    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
    ];
    packages = with pkgs; [
      devenv
      jq
      k9s
      pandoc
      python311
      python314Packages.uv
      ripgrep
      sbt
      curl-impersonate
      unar
      wget
      vlc-bin
      fd
      kubectx
      mermaid-cli
      bat
      tealdeer
      inputs.korb.packages.${pkgs.stdenv.hostPlatform.system}.default
      jdk21
    ];
  };
  programs = {
    home-manager.enable = true;

    nix-index.enable = true;

    # merged from imports = []
    nix-index-database.comma.enable = true;

    nh = {
      enable = true;
      flake = "/Users/yannickgladow/nix-config";
    };

    nix-your-shell.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    gh.enable = true;

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
    };

  };

}
