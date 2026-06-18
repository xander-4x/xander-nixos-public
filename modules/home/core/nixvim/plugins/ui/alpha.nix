_: {
  plugins.alpha = {
    enable = true;
    settings.layout = [
      {
        type = "padding";
        val = 4;
      }
      {
        type = "text";
        val = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        opts = {
          hl = "AlphaHeader";
          position = "center";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = " 󰈞  Find File";
            on_press.__raw = "function() require('telescope.builtin').find_files() end";
            opts = {
              shortcut = "<leader>ff";
              width = 40;
              position = "center";
              hl = "AlphaButtons";
              hl_shortcut = "AlphaShortcut";
            };
          }
          {
            type = "button";
            val = " 󰍉  Find Word";
            on_press.__raw = "function() require('telescope.builtin').live_grep() end";
            opts = {
              shortcut = "<leader>/ ";
              width = 40;
              position = "center";
              hl = "AlphaButtons";
              hl_shortcut = "AlphaShortcut";
            };
          }
          {
            type = "button";
            val = " 󰋚  Recent Files";
            on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
            opts = {
              shortcut = "<leader>fg";
              width = 40;
              position = "center";
              hl = "AlphaButtons";
              hl_shortcut = "AlphaShortcut";
            };
          }
          {
            type = "button";
            val = " 󰉋  File Browser";
            on_press.__raw = "function() require('neo-tree.command').execute({ toggle = true }) end";
            opts = {
              shortcut = "<leader>e ";
              width = 40;
              position = "center";
              hl = "AlphaButtons";
              hl_shortcut = "AlphaShortcut";
            };
          }
          {
            type = "button";
            val = " 󰩈  Quit";
            on_press.__raw = "function() vim.cmd('qa') end";
            opts = {
              shortcut = "<leader>qq";
              width = 40;
              position = "center";
              hl = "AlphaButtons";
              hl_shortcut = "AlphaShortcut";
            };
          }
        ];
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = "nixvim";
        opts = {
          hl = "AlphaFooter";
          position = "center";
        };
      }
    ];
  };
}
