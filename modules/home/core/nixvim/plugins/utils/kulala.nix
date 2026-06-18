{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [ kulala-nvim ];

  extraConfigLua = ''
    require('kulala').setup({
      default_view = "body",
      default_env = "dev",
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>rr";
      action = "<cmd>lua require('kulala').run()<cr>";
      options.desc = "Run HTTP Request";
    }
    {
      mode = "n";
      key = "<leader>ra";
      action = "<cmd>lua require('kulala').run_all()<cr>";
      options.desc = "Run All HTTP Requests";
    }
    {
      mode = "n";
      key = "<leader>rn";
      action = "<cmd>lua require('kulala').jump_next()<cr>";
      options.desc = "Next HTTP Request";
    }
    {
      mode = "n";
      key = "<leader>rp";
      action = "<cmd>lua require('kulala').jump_prev()<cr>";
      options.desc = "Prev HTTP Request";
    }
    {
      mode = "n";
      key = "<leader>rc";
      action = "<cmd>lua require('kulala').copy()<cr>";
      options.desc = "Copy as cURL";
    }
  ];
}
