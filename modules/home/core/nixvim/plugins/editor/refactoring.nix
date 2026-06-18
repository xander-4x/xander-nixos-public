{ pkgs, ... }: {
  plugins.refactoring.enable = true;

  extraPlugins = with pkgs.vimPlugins; [ inc-rename-nvim ];

  extraConfigLua = ''
    require("inc_rename").setup()

    -- Override LSP rename with live-preview rename
    vim.keymap.set("n", "<leader>cr", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename (live preview)" })
  '';

  keymaps = [
    {
      mode = "v";
      key = "<leader>Rf";
      action.__raw = "function() require('refactoring').refactor('Extract Function') end";
      options.desc = "Extract Function";
    }
    {
      mode = "v";
      key = "<leader>Rv";
      action.__raw = "function() require('refactoring').refactor('Extract Variable') end";
      options.desc = "Extract Variable";
    }
    {
      mode = [ "n" "v" ];
      key = "<leader>Ri";
      action.__raw = "function() require('refactoring').refactor('Inline Variable') end";
      options.desc = "Inline Variable";
    }
    {
      mode = "n";
      key = "<leader>Rb";
      action.__raw = "function() require('refactoring').refactor('Extract Block') end";
      options.desc = "Extract Block";
    }
  ];
}
