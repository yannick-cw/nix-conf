{ ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user.name = "Yannick Gladow";
      user.email = "yannick.gladow@gmail.com";

      init.defaultBranch = "main";

      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };

      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };

      core = {
        autocrlf = "input";
        excludesfile = "/Users/yannickgladow/.gitignore_global";
      };

      pull.rebase = false;
      rebase.updateRefs = true;

      alias = {
        pn = "!git push --set-upstream origin \"$(git rev-parse --abbrev-ref HEAD)\"";
        ls = "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn] %Creset%Cgreen (%cr)' --decorate";
        ll = "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]' --decorate --numstat";
        c = "commit -m";
        s = "status";
        co = "checkout";
        fixup = "!sh -c 'REV=$(git rev-parse $1) && git commit --fixup $@ && GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash $REV^' -";
      };
    };

    # conditional per-folder identity (was [includeIf "gitdir:..."])
    includes = [
      { condition = "gitdir:~/workspace/";      path = "~/workspace/.gitconfig"; }
      { condition = "gitdir:~/otherworkspace/"; path = "~/otherworkspace/.gitconfig"; }
    ];
  };
}
