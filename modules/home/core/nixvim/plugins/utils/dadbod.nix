_: {
  plugins.vim-dadbod.enable = true;
  plugins.vim-dadbod-ui.enable = true;
  plugins.vim-dadbod-completion.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>Du";
      action = "<cmd>DBUIToggle<cr>";
      options.desc = "Toggle DB UI";
    }
    {
      mode = "n";
      key = "<leader>Da";
      action = "<cmd>DBUIAddConnection<cr>";
      options.desc = "Add DB Connection";
    }
  ];
}
