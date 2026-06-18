_: {
  plugins.dap.enable = true;
  plugins.dap-ui.enable = true;
  plugins.dap-virtual-text.enable = true;
  plugins.dap-go.enable = true;
  plugins.dap-python = {
    enable = true;
    adapterPythonPath = "python3";
  };

  keymaps = [
    {
      mode = "n";
      key = "<F5>";
      action = "<cmd>lua require('dap').continue()<cr>";
      options.desc = "Debug: Continue";
    }
    {
      mode = "n";
      key = "<F10>";
      action = "<cmd>lua require('dap').step_over()<cr>";
      options.desc = "Debug: Step Over";
    }
    {
      mode = "n";
      key = "<F11>";
      action = "<cmd>lua require('dap').step_into()<cr>";
      options.desc = "Debug: Step Into";
    }
    {
      mode = "n";
      key = "<F12>";
      action = "<cmd>lua require('dap').step_out()<cr>";
      options.desc = "Debug: Step Out";
    }
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
      options.desc = "Toggle Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dB";
      action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>";
      options.desc = "Conditional Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>du";
      action = "<cmd>lua require('dapui').toggle()<cr>";
      options.desc = "Toggle DAP UI";
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = "<cmd>lua require('dap').repl.open()<cr>";
      options.desc = "Open REPL";
    }
    {
      mode = "n";
      key = "<leader>dl";
      action = "<cmd>lua require('dap').run_last()<cr>";
      options.desc = "Run Last";
    }
    {
      mode = "n";
      key = "<leader>dt";
      action = "<cmd>lua require('dap').terminate()<cr>";
      options.desc = "Terminate";
    }
  ];
}
