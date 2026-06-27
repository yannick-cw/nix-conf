{ pkgs, ... }:
{
  home = {
    stateVersion = "25.05"; 
    sessionVariables = { EDITOR = "nvim"; KORB_CURL = "curl_safari184_ios"; };
    sessionPath = [ "$HOME/bin" "$HOME/.local/bin" ];
    packages = [ pkgs.ripgrep ];
  };
  programs.home-manager.enable = true;

  programs.ghostty = {
    enable = true;
    package = null; # via cask
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;

      macos-option-as-alt = true;

      # tabs merged into the titlebar (single bar, like iTerm) instead of two bars
      macos-titlebar-style = "tabs";

      # light theme — run `ghostty +list-themes` to browse; names are Title Case
      theme = "Rose Pine Dawn";

      cursor-style = "block";
      cursor-style-blink = false;

      window-padding-x = 8;
      window-padding-y = 8;
      scrollback-limit = 10000000;
      confirm-close-surface = true;

      shell-integration = "zsh";
      shell-integration-features = "cursor,sudo,title";

      # autostart: launch hidden, stay resident for the quick terminal
      initial-window = false;
      quit-after-last-window-closed = false;

      keybind = [ "global:cmd+grave_accent=toggle_quick_terminal" ];
      quick-terminal-position = "top";
    };
  };
  programs.fzf.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo darwin-rebuild switch --flake ~/nix-config";
      vim = "nvim"; k = "kubectl"; kc = "kubectx"; kn = "kubens";
    };
    history.size = 10000;

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
  };

  # autostart Ghostty at login so the quick terminal is always summonable
  launchd.agents.ghostty = {
    enable = true;
    config = {
      ProgramArguments = [ "/Applications/Ghostty.app/Contents/MacOS/ghostty" ];
      RunAtLoad = true;
    };
  };
}
