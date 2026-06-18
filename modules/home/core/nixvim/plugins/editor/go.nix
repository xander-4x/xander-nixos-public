{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.go-nvim
    pkgs.vimPlugins.guihua-lua
  ];

  extraConfigLua = ''
    require("go").setup()
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>ot";
      action = "<cmd>GoTest<cr>";
      options.desc = "Go Test";
    }
    {
      mode = "n";
      key = "<leader>oT";
      action = "<cmd>GoTestFile<cr>";
      options.desc = "Go Test File";
    }
    {
      mode = "n";
      key = "<leader>oa";
      action = "<cmd>GoAddTags<cr>";
      options.desc = "Go Add Tags";
    }
    {
      mode = "n";
      key = "<leader>oe";
      action = "<cmd>GoIfErr<cr>";
      options.desc = "Go Add if err";
    }
    {
      mode = "n";
      key = "<leader>of";
      action = "<cmd>GoFmt<cr>";
      options.desc = "Go Format";
    }
    {
      mode = "n";
      key = "<leader>oi";
      action = "<cmd>GoImports<cr>";
      options.desc = "Go Imports";
    }
    {
      mode = "n";
      key = "<leader>od";
      action = "<cmd>GoDoc<cr>";
      options.desc = "Go Doc";
    }
  ];
}
