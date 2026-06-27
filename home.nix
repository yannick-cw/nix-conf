{ pkgs, ... }:
{
  imports = [ ./ghostty.nix ];
  home = {
    stateVersion = "25.05"; 
    sessionVariables = { EDITOR = "nvim"; KORB_CURL = "curl_safari184_ios"; };
    sessionPath = [ "$HOME/bin" "$HOME/.local/bin" ];
    packages = with pkgs; [
      jq k9s pandoc python311 ripgrep sbt unar wget fd kubectx mermaid-cli  
      git           # config still in ~/.gitconfig (migrate to programs.git later)
      neovim        # config still in ~/.config/nvim (migrate to programs.neovim later)
    ];
  };
  programs.home-manager.enable = true;

  programs.fzf.enable = true;
  programs.gh.enable = true;   # installs gh + sets it as git credential helper
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo darwin-rebuild switch --flake ~/nix-config";
      vim = "nvim"; k = "kubectl"; kc = "kubectx"; kn = "kubens";
    };
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;          # collapse repeated commands
      ignoreSpace = true;         # commands starting with space aren't recorded
      expireDuplicatesFirst = true;
      share = true;               # share history live across open shells
      extended = true;            # timestamps
    };
    oh-my-zsh = { # "ohMyZsh" without Home Manager
      enable = true;
      plugins = [ "git" "docker" "macos" "docker-compose" "z" "per-directory-history" ];
      theme = "avit";
    };
    initContent = ''
      bindkey "^[[A" history-beginning-search-backward
      bindkey "^[[B" history-beginning-search-forward
      # also bind application-cursor-key mode, so it works in all terminals
      bindkey "^[OA" history-beginning-search-backward
      bindkey "^[OB" history-beginning-search-forward
      export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
      [ -f ~/.zsh_secrets ] && source ~/.zsh_secrets
    '';
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
