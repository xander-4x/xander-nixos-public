{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        hashicorp.terraform
        yzhang.markdown-all-in-one
        yzane.markdown-pdf
        zainchen.json
        jnoortheen.nix-ide
      ];
      userSettings = {
        "update.mode" = "none";
        "workbench.colorTheme" = lib.mkForce "Dracula Theme";
        "diffEditor.maxComputationTime" = 5000;
        "git.autofetch" = false;
        "extensions.ignoreRecommendations" = true;
        "workbench.startupEditor" = "none";
        "window.restoreWindows" = "one";
        "disable-hardware-acceleration" = false;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "terminal.integrated.tabStopWidth" = 2;
        "security.workspace.trust.untrustedFiles" = "open";
        "extensions.trustedPublishers" = [
          "bierner"
          "tomoki1207"
          "yzane"
          "yzhang"
          "davidanson"
        ];
        "files.associations" = {
          "*.json" = "jsonc";
          "*.mdx" = "markdown";
        };
        "workbench.editorAssociations" = {
          "*.copilotmd" = "vscode.markdown.preview.editor";
          "*.log" = "default";
        };
        "git.openRepositoryInParentFolders" = "always";
        "editor.wordWrap" = "on";
        "git.confirmSync" = false;
      };
    };
  };
}
