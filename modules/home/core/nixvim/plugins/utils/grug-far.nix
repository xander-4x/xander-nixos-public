_: {
  plugins.grug-far = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>sr";
      action = "<cmd>GrugFar<cr>";
      options.desc = "Search & Replace (GrugFar)";
    }
    {
      mode = "v";
      key = "<leader>sr";
      action = "<cmd>GrugFar<cr>";
      options.desc = "Search & Replace (selection)";
    }
  ];
}
