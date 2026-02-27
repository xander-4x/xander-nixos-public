{ ... }:
{
  extraConfigLua = ''
      -- SSHFS integration for remote file editing with neo-tree

      -- Mount points directory
      local mount_base = vim.fn.expand("$HOME/mnt/ssh")

      -- Ensure mount directory exists
      vim.fn.mkdir(mount_base, "p")

      -- Table to track mounted filesystems
      _G.sshfs_mounts = {}

      -- Function to mount SSHFS
      local function mount_sshfs(host, remote_path, mount_name)
        -- Create mount point
        local mount_point = mount_base .. "/" .. mount_name
        vim.fn.mkdir(mount_point, "p")

        -- Check if already mounted
        local check = vim.fn.system("mountpoint -q " .. vim.fn.shellescape(mount_point))
        if vim.v.shell_error == 0 then
          vim.notify("Already mounted at " .. mount_point, vim.log.levels.WARN)
          return mount_point
        end

        -- Mount with SSHFS
        local cmd = string.format(
          "sshfs %s:%s %s -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3",
          host, remote_path, vim.fn.shellescape(mount_point)
        )

        vim.notify("Mounting " .. host .. ":" .. remote_path .. "...", vim.log.levels.INFO)
        local result = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to mount: " .. result, vim.log.levels.ERROR)
          return nil
        end

        -- Track mounted filesystem
        _G.sshfs_mounts[mount_name] = {
          host = host,
          remote_path = remote_path,
          mount_point = mount_point,
        }

        vim.notify("Mounted successfully at " .. mount_point, vim.log.levels.INFO)
        return mount_point
      end

      -- Function to unmount SSHFS
      local function unmount_sshfs(mount_name)
        local mount_info = _G.sshfs_mounts[mount_name]
        if not mount_info then
          vim.notify("Mount '" .. mount_name .. "' not found", vim.log.levels.ERROR)
          return false
        end

        local mount_point = mount_info.mount_point

        -- Unmount
        local cmd = "fusermount -u " .. vim.fn.shellescape(mount_point)
        vim.notify("Unmounting " .. mount_point .. "...", vim.log.levels.INFO)
        local result = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to unmount: " .. result, vim.log.levels.ERROR)
          return false
        end

        _G.sshfs_mounts[mount_name] = nil
        vim.notify("Unmounted successfully", vim.log.levels.INFO)
        return true
      end

      -- Function to list all mounts
      local function list_mounts()
        if vim.tbl_count(_G.sshfs_mounts) == 0 then
          vim.notify("No active SSHFS mounts", vim.log.levels.INFO)
          return
        end

        local lines = {"Active SSHFS mounts:", ""}
        for name, info in pairs(_G.sshfs_mounts) do
          table.insert(lines, string.format("  %s: %s:%s -> %s",
            name, info.host, info.remote_path, info.mount_point))
        end

        vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
      end

      -- Command to mount and open in neo-tree
      vim.api.nvim_create_user_command('SSHMount', function(opts)
        local args = vim.split(opts.args, "%s+")

        if #args < 1 then
          vim.notify("Usage: :SSHMount <host> [remote_path] [mount_name]", vim.log.levels.ERROR)
          return
        end

        local host = args[1]
        local remote_path = args[2] or "/"
        local mount_name = args[3] or host:gsub("[^%w]", "_")

        local mount_point = mount_sshfs(host, remote_path, mount_name)

        if mount_point then
          -- Open in neo-tree
          vim.cmd("Neotree " .. mount_point)
        end
      end, {
        nargs = "+",
        desc = "Mount SSHFS and open in neo-tree",
        complete = function()
          -- Read SSH hosts from config for completion
          local ssh_config = vim.fn.expand("$HOME/.ssh/config")
          if vim.fn.filereadable(ssh_config) == 1 then
            local hosts = {}
            for line in io.lines(ssh_config) do
              local host = line:match("^Host%s+([^%s*]+)")
              if host then
                table.insert(hosts, host)
              end
            end
            return hosts
          end
          return {}
        end
      })

      -- Command to unmount
      vim.api.nvim_create_user_command('SSHUnmount', function(opts)
        if opts.args == "" then
          vim.notify("Usage: :SSHUnmount <mount_name>", vim.log.levels.ERROR)
          return
        end
        unmount_sshfs(opts.args)
      end, {
        nargs = 1,
        desc = "Unmount SSHFS",
        complete = function()
          local names = {}
          for name, _ in pairs(_G.sshfs_mounts) do
            table.insert(names, name)
          end
          return names
        end
      })

      -- Command to list mounts
      vim.api.nvim_create_user_command('SSHList', function()
        list_mounts()
      end, {
        desc = "List active SSHFS mounts"
      })

      -- Command to unmount all
      vim.api.nvim_create_user_command('SSHUnmountAll', function()
        local names = {}
        for name, _ in pairs(_G.sshfs_mounts) do
          table.insert(names, name)
        end

        for _, name in ipairs(names) do
          unmount_sshfs(name)
        end
      end, {
        desc = "Unmount all SSHFS mounts"
      })

      -- Auto-unmount on exit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          for name, _ in pairs(_G.sshfs_mounts) do
            unmount_sshfs(name)
          end
        end
      })
    '';
}
