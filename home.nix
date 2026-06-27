{ pkgs, ... }:
{
  home.stateVersion = "25.05"; 
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

  # autostart Ghostty at login so the quick terminal is always summonable
  launchd.agents.ghostty = {
    enable = true;
    config = {
      ProgramArguments = [ "/Applications/Ghostty.app/Contents/MacOS/ghostty" ];
      RunAtLoad = true;
    };
  };

  # start tiny to prove it works:
  home.packages = [ pkgs.ripgrep ];
}
