{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;

      alias = {
        st      = "status";
        co      = "checkout";
        br      = "branch";
        ci      = "commit";
        unstage = "reset HEAD --";
        last    = "log -1 HEAD";
        lg      = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };

    ignores = [
      "*~" "*.swp" "*.swo"
      ".DS_Store" "Thumbs.db"
      ".idea/" ".vscode/"
      "*.log"
    ];
  };
}
