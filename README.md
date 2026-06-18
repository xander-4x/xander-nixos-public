# NixOS Configuration

A modular NixOS configuration with clear separation between core system modules, desktop environment, server configuration, and home-manager settings.

> This configuration is originally based on the
> [ZaneyOS repository](https://gitlab.com/Zaney/zaneyos).

## Features

- **Modular architecture** - Easy to create desktop or server configurations
- **Hyprland** - Wayland compositor with custom animations and keybindings
- **DankMaterialShell (DMS)** - Integrated desktop shell replacing waybar, rofi, swaync, hyprlock, and hypridle
- **Stylix** - Automatic system-wide theming based on wallpaper
- **Home Manager** - Declarative user environment management
- **NixVim** - Fully configured Neovim with LSP, completion, and plugins
- **Steam Deck support** - Jovian-NixOS Gaming Mode + minimal Plasma 6 Desktop Mode

## Hosts

| Host              | Type       | Description                                             |
| ----------------- | ---------- | ------------------------------------------------------- |
| `desktop`   | Desktop    | Laptop / desktop workstation                        |
| `server`    | Server     | Headless server                                     |
| `steamdeck` | Steam Deck | Jovian-NixOS — Gaming Mode + Plasma 6 Desktop Mode  |

## Project Structure

```
.
├── flake.nix                 # Flake configuration and inputs
├── wallpapers/               # Wallpapers for Stylix theming
│
├── hosts/
│   ├── desktop/              # Desktop / laptop workstation
│   │   ├── default.nix       # Host configuration (imports modules)
│   │   ├── hardware.nix      # Hardware-specific settings
│   │   ├── variables.nix     # Host variables (customize here!)
│   │   ├── user.nix          # User & home-manager setup
│   │   ├── host-packages.nix # System packages
│   │   ├── kernel-tuning.nix # i915 / iommu kernel params
│   │   ├── thinkpad.nix      # ThinkPad power management (TLP, battery limit, thermald)
│   │   ├── hibernate.nix     # LUKS+Btrfs swapfile hibernation, suspend-then-hibernate on lid close
│   │   └── zram.nix          # Swap configuration
│   │
│   ├── server/               # Server (headless)
│   │   ├── default.nix       # Host configuration
│   │   ├── hardware.nix      # Hardware-specific settings
│   │   ├── variables.nix     # Host variables
│   │   ├── user.nix          # User & home-manager setup
│   │   ├── host-packages.nix # System packages
│   │   └── zram.nix          # Swap configuration
│   │
│   └── steamdeck/            # Steam Deck (Jovian-NixOS)
│       ├── default.nix       # Host configuration
│       ├── hardware.nix      # Hardware-specific settings
│       ├── variables.nix     # Host variables
│       ├── user.nix          # User & home-manager setup
│       ├── host-packages.nix # System packages
│       ├── plasma-session.nix# Plasma 6 Desktop Mode session
│       └── zram.nix          # Swap configuration
│
└── modules/
    ├── core/                 # Shared base system (desktop & server)
    │   ├── system.nix        # Hostname, timezone, locale, nix settings
    │   ├── security.nix      # Polkit
    │   ├── nfs.nix           # NFS server
    │   ├── nh.nix            # Nix helper
    │   ├── starfish.nix      # Starship prompt
    │   └── syncthing.nix     # Syncthing
    │
    ├── desktop/              # Desktop-specific (NixOS level)
    │   ├── boot.nix          # Bootloader, kernel, plymouth
    │   ├── network.nix       # NetworkManager, firewall
    │   ├── hardware.nix      # Graphics, scanners
    │   ├── services.nix      # Desktop services (asusd, gnome-keyring)
    │   ├── audio.nix         # Pipewire
    │   ├── bluetooth.nix     # Bluetooth support
    │   ├── fonts.nix         # System fonts
    │   ├── greetd.nix        # Login manager
    │   ├── stylix.nix        # Theming
    │   ├── tlp.nix           # Laptop power management
    │   └── ...
    │
    ├── server/               # Server-specific
    │   ├── boot.nix          # Simple bootloader, kernel
    │   ├── network.nix       # Minimal network (DHCP, SSH only)
    │   └── services.nix      # SSH hardening, fstrim, tailscale
    │
    ├── gaming/               # Gaming (Steam, Lutris, Jovian Steam Deck stack)
    │
    ├── virtualisation/       # Container and VM support
    │   ├── podman.nix        # Podman + Docker compat (server & desktop)
    │   └── libvirt.nix       # libvirtd, virt-manager (desktop only)
    │
    ├── drivers/              # GPU drivers (NVIDIA, AMD, Intel)
    │
    └── home/                 # Home-manager modules
        ├── core/             # CLI tools (works on servers too)
        │   ├── nixvim/       # Neovim configuration
        │   ├── zsh/          # Shell configuration
        │   ├── git.nix       # Git config
        │   ├── yazi/         # TUI file manager
        │   └── ...
        │
        └── desktop/          # GUI applications
            ├── hyprland/     # Window manager
            ├── dms.nix       # DankMaterialShell (replaces waybar, rofi, swaync, hyprlock, hypridle)
            ├── waybar/       # Status bar (used when shellChoice = "waybar")
            ├── rofi/         # Application launcher (used when shellChoice = "waybar")
            ├── dev/          # Development tools (VSCodium, cloud-tools)
            └── ...
```

## NixVim

Fully declarative Neovim configuration managed via [NixVim](https://github.com/nix-community/nixvim). Located in `modules/home/core/nixvim/`.

### LSP Servers

| Server                            | Language                                                               |
| --------------------------------- | ---------------------------------------------------------------------- |
| `lua_ls`                          | Lua                                                                    |
| `nil_ls`                          | Nix                                                                    |
| `typescript-tools`                | TypeScript / JavaScript                                                |
| `pyright`                         | Python                                                                 |
| `gopls`                           | Go                                                                     |
| `html`                            | HTML                                                                   |
| `jsonls`                          | JSON                                                                   |
| `yamlls`                          | YAML (schemas: Kubernetes, GitHub Actions, Helm, Docker Compose, Argo) |
| `terraformls`                     | Terraform                                                              |
| `helm_ls`                         | Helm (uses yamlls internally)                                          |
| `dockerls`                        | Dockerfile                                                             |
| `docker_compose_language_service` | Docker Compose                                                         |
| `marksman`                        | Markdown                                                               |
| `nginx_language_server`           | Nginx                                                                  |

### Plugins

| Category       | Plugin                | Description                         |
| -------------- | --------------------- | ----------------------------------- |
| **Completion** | nvim-cmp              | Completion engine                   |
|                | copilot-cmp           | — removed                           |
|                | luasnip               | Snippet engine                      |
|                | lspkind               | VS Code-style completion icons      |
|                | nvim-autopairs        | Auto-close brackets                 |
|                | schemastore           | JSON/YAML schema catalog            |
| **LSP**        | nvim-lspconfig        | LSP client configuration            |
|                | lsp-lines             | Inline diagnostic rendering         |
|                | lsp-format            | Format on save via LSP              |
|                | conform.nvim          | Formatter (prettier, black, gofmt…) |
|                | fidget.nvim           | LSP progress notifications          |
| **Debug**      | nvim-dap              | Debug Adapter Protocol core         |
|                | nvim-dap-ui           | Debug UI panels                     |
|                | nvim-dap-virtual-text | Variable values inline              |
|                | nvim-dap-go           | Go debug adapter (delve)            |
|                | nvim-dap-python       | Python debug adapter                |
| **Editor**     | nvim-treesitter       | Syntax highlighting & indentation   |
|                | neo-tree              | File explorer sidebar               |
|                | undotree              | Visual undo history                 |
|                | illuminate            | Highlight word under cursor         |
|                | indent-blankline      | Indent guides                       |
|                | todo-comments         | Highlight TODO/FIXME/NOTE           |
|                | rainbow-delimiters    | Coloured bracket pairs              |
|                | navic                 | LSP breadcrumbs in statusline       |
| **Git**        | lazygit.nvim          | Full Git TUI inside Neovim          |
|                | gitsigns.nvim         | Git signs in gutter                 |
|                | diffview.nvim         | Git diff viewer & merge tool        |
| **UI**         | bufferline.nvim       | Tab bar                             |
|                | lualine.nvim          | Statusline                          |
|                | startup.nvim          | Dashboard                           |
|                | trouble.nvim          | Diagnostics list panel              |
|                | which-key.nvim        | Keybinding hints                    |
|                | web-devicons          | File type icons                     |
| **Utils**      | telescope.nvim        | Fuzzy finder                        |
|                | grug-far.nvim         | Project-wide search & replace       |
|                | kulala.nvim           | HTTP client (`.http` files)         |
|                | vim-dadbod + UI       | SQL database client                 |
|                | mini.nvim             | surround, comment, indentscope      |
|                | toggleterm.nvim       | Floating terminal                   |
|                | markdown-preview.nvim | Live markdown preview in browser    |
|                | obsidian.nvim         | Obsidian vault integration          |

### Keybindings

> Leader key: `Space`

#### General

| Key                        | Action                     |
| -------------------------- | -------------------------- |
| `<C-s>`                    | Save file                  |
| `<C-/>`                    | Toggle comment             |
| `<A-j/k>`                  | Move line up/down          |
| `<C-h/j/k/l>`              | Navigate windows           |
| `<leader>-` / `<leader>\|` | Split window below / right |
| `<leader>qq`               | Force quit                 |
| `<leader>qw`               | Save and quit              |

#### Files & Search

| Key               | Action                     |
| ----------------- | -------------------------- |
| `<leader><space>` | Find files                 |
| `<leader>/`       | Live grep                  |
| `<C-p>`           | Git files                  |
| `<leader>ff`      | Find files                 |
| `<leader>fr`      | Find text                  |
| `<leader>fg`      | Recent files               |
| `<leader>fb`      | Buffers                    |
| `<leader>fe`      | File browser               |
| `<leader>sk`      | Search keymaps             |
| `<leader>sh`      | Help pages                 |
| `<leader>sr`      | Search & replace (GrugFar) |

#### Code / LSP

| Key          | Action                 |
| ------------ | ---------------------- |
| `gd`         | Go to definition       |
| `gr`         | Go to references       |
| `gD`         | Go to declaration      |
| `gI`         | Go to implementation   |
| `gT`         | Type definition        |
| `K`          | Hover documentation    |
| `<leader>cr` | Rename symbol          |
| `<leader>cd` | Line diagnostics       |
| `]d` / `[d`  | Next / prev diagnostic |
| `]e` / `[e`  | Next / prev error      |
| `]w` / `[w`  | Next / prev warning    |

#### Diagnostics (Trouble)

| Key          | Action                |
| ------------ | --------------------- |
| `<leader>xx` | Document diagnostics  |
| `<leader>xX` | Workspace diagnostics |
| `<leader>xs` | Symbols               |
| `<leader>xq` | Quickfix list         |
| `<leader>xl` | Location list         |

#### Git

| Key          | Action                      |
| ------------ | --------------------------- |
| `<leader>gg` | LazyGit                     |
| `<leader>gc` | Commits (Telescope)         |
| `<leader>gs` | Git status (Telescope)      |
| `<leader>gd` | Open Diffview               |
| `<leader>gh` | File history (current file) |
| `<leader>gH` | File history (repo)         |
| `<leader>gD` | Close Diffview              |

#### Debug (DAP)

| Key          | Action                 |
| ------------ | ---------------------- |
| `<F5>`       | Continue / Start       |
| `<F10>`      | Step over              |
| `<F11>`      | Step into              |
| `<F12>`      | Step out               |
| `<leader>db` | Toggle breakpoint      |
| `<leader>dB` | Conditional breakpoint |
| `<leader>du` | Toggle DAP UI          |
| `<leader>dr` | Open REPL              |
| `<leader>dl` | Run last               |
| `<leader>dt` | Terminate              |

#### HTTP / REST (Kulala)

| Key          | Action                   |
| ------------ | ------------------------ |
| `<leader>rr` | Run request under cursor |
| `<leader>ra` | Run all requests         |
| `<leader>rn` | Next request             |
| `<leader>rp` | Previous request         |
| `<leader>rc` | Copy as cURL             |

#### Database (Dadbod)

| Key          | Action         |
| ------------ | -------------- |
| `<leader>Du` | Toggle DB UI   |
| `<leader>Da` | Add connection |

#### Markdown

| Key          | Action                    |
| ------------ | ------------------------- |
| `<leader>mp` | Toggle preview in browser |

## Installation

### Fresh NixOS Install

1. Boot into NixOS installer and complete minimal installation

2. After reboot, enter a shell with required tools:

```bash
nix-shell -p git vim
```

3. Clone this repository:

```bash
git clone https://github.com/yourusername/nixos-config.git
cd nixos-config
```

4. Generate hardware configuration for your machine:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/myhost/hardware.nix
```

5. Edit `hosts/myhost/variables.nix` with your settings (username, git config, monitors, etc.)

6. Update `flake.nix` with your hostname and username

7. Enable flakes and rebuild:

```bash
NIX_CONFIG="experimental-features = nix-command flakes" sudo nixos-rebuild switch --flake .#myhost
```

8. Reboot and enjoy your new system. After first rebuild, you can use the `nix-rebuild` alias.

## Shell Aliases

| Alias         | Command                                   | Description                               |
| ------------- | ----------------------------------------- | ----------------------------------------- |
| `nix-rebuild` | `nh os switch --hostname <host>`          | Rebuild and switch to new configuration   |
| `nix-update`  | `nh os switch --hostname <host> --update` | Update flake inputs and rebuild           |
| `nix-clear`   | `nix-collect-garbage...`                  | Clean old generations and garbage collect |
| `vim`         | `nvim`                                    | Nixvim                                    |
| `cat`         | `bat`                                     | Cat with syntax highlighting              |
| `ls`          | `eza --icons...`                          | Modern ls replacement                     |
| `ll`          | `eza -lh...`                              | Long listing                              |
| `la`          | `eza -lah...`                             | Long listing with hidden files            |
| `tree`        | `eza --tree...`                           | Tree view                                 |

## Creating a New Desktop Host

### 1. Create host directory

```bash
mkdir -p hosts/myhost
```

### 2. Create configuration files

**hosts/myhost/default.nix:**

```nix
{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./user.nix
    ./zram.nix

    # Core system (required)
    ../../modules/core

    # Desktop environment
    ../../modules/desktop

    # Optional:
    ../../modules/gaming          # For gaming
    ../../modules/virtualisation  # For Docker/VMs
    ../../modules/drivers         # For GPU drivers
  ];

  # GPU configuration (if using drivers)
  drivers.nvidia.enable = false;
  drivers.amdgpu.enable = true;
  drivers.intel.enable = false;

  system.stateVersion = "25.11";
}
```

**hosts/myhost/variables.nix:**

```nix
{
  # Required
  gitUsername = "Your Name";
  gitEmail = "your@email.com";

  # Desktop settings
  keyboardLayout = "us";
  consoleKeyMap = "us";
  browser = "firefox";
  terminal = "wezterm";

  # Hyprland monitors
  extraMonitorSettings = ''
    monitor=,preferred,auto,1
  '';

  # Desktop shell choice
  # "dms"    = DankMaterialShell (replaces waybar, swaync, hyprlock, hypridle)
  # "waybar" = traditional waybar + swaync setup
  shellChoice = "dms";

  # Theming
  stylixImage = ../../wallpapers/your-wallpaper.jpg;
  waybarChoice = ../../modules/home/desktop/waybar/waybar-curved.nix; # only when shellChoice = "waybar"
  animChoice = ../../modules/home/desktop/hyprland/animations-end4.nix;

  # Optional features
  thunarEnable = true;
  printEnable = false;
  enableNFS = false;
  clock24h = true;
}
```

**hosts/myhost/user.nix:**

```nix
{pkgs, inputs, username, host, ...}: let
  inherit (import ./variables.nix) gitUsername;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    extraSpecialArgs = {inherit inputs username host;};
    users.${username} = {
      imports = [
        ../../modules/home           # Full (core + desktop)
        inputs.nixvim.homeModules.nixvim
      ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
      };
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
  };
}
```

**hosts/myhost/hardware.nix:**

```bash
# Generate with:
sudo nixos-generate-config --show-hardware-config > hosts/myhost/hardware.nix
```

### 3. Add to flake.nix

```nix
nixosConfigurations = {
  "myhost" = mkHost "myhost" "nixuser";
};
```

### 4. Build

```bash
sudo nixos-rebuild switch --flake .#myhost
```

## Creating a Server (Headless)

For a server without GUI, use `modules/server` instead of `modules/desktop`:

**hosts/myserver/default.nix:**

```nix
{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./user.nix
    ./zram.nix

    # Core system (required)
    ../../modules/core

    # Server-specific
    ../../modules/server

    # Optional:
    ../../modules/virtualisation/podman.nix  # For containers (no VMs)
    # ../../modules/virtualisation            # For containers + VMs (includes libvirt)
  ];

  system.stateVersion = "25.11";
}
```

**hosts/myserver/variables.nix:**

```nix
{
  gitUsername = "Your Name";
  gitEmail = "your@email.com";
  enableNFS = false;
}
```

**hosts/myserver/user.nix:**

```nix
{pkgs, inputs, username, host, ...}: let
  inherit (import ./variables.nix) gitUsername;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    extraSpecialArgs = {inherit inputs username host;};
    users.${username} = {
      imports = [
        ../../modules/home/core  # CLI only (no desktop)
      ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
      };
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAA..."
    ];
  };

  # Root SSH access (optional)
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAA..."
  ];
}
```

### Remote deployment

Deploy to server from your local machine:

```bash
nixos-rebuild switch --flake .#myserver --target-host root@myserver
```

### Enable rootless Podman

After first deployment, enable the user podman socket:

```bash
systemctl --user enable --now podman.socket
```

## Module Overview

| Module                               | Type    | Description                                                      |
| ------------------------------------ | ------- | ---------------------------------------------------------------- |
| `modules/core`                       | Shared  | Base system: hostname, timezone, locale, nix settings, security  |
| `modules/desktop`                    | Desktop | Boot, network, hardware, services, audio, bluetooth, theming     |
| `modules/server`                     | Server  | Minimal boot, network (SSH), services (fstrim, tailscale), zsh   |
| `modules/gaming`                     | Desktop | Steam, Lutris, game streaming; `jovian.nix` for Steam Deck stack |
| `modules/virtualisation`             | Desktop | Full: Podman + libvirt + virt-manager                            |
| `modules/virtualisation/podman.nix`  | Both    | Podman with Docker compatibility (rootless)                      |
| `modules/virtualisation/libvirt.nix` | Desktop | libvirtd, virt-manager, SPICE                                    |
| `modules/drivers`                    | Desktop | NVIDIA, AMD, Intel GPU drivers                                   |
| `modules/home/core`                  | Both    | CLI tools: zsh, git, yazi, btop, starship, NixVim                |
| `modules/home/desktop`               | Desktop | GUI: Hyprland, DMS or waybar/rofi/swaync, terminals, xdg         |

## Key Files to Customize

| File                                            | Purpose                                   |
| ----------------------------------------------- | ----------------------------------------- |
| `hosts/<host>/variables.nix`                    | Host-specific settings, theming, monitors |
| `hosts/<host>/host-packages.nix`                | System packages                           |
| `hosts/<host>/user.nix`                         | User configuration, home-manager imports  |
| `modules/home/core/zsh/zshrc-personal.nix`      | Personal shell config                     |
| `modules/home/desktop/hyprland/binds.nix`       | Keybindings                               |
| `modules/home/desktop/hyprland/windowrules.nix` | Window rules                              |

## Inputs

| Input                                                         | Description                    |
| ------------------------------------------------------------- | ------------------------------ |
| [nixpkgs](https://github.com/nixos/nixpkgs)                   | NixOS unstable                 |
| [home-manager](https://github.com/nix-community/home-manager) | User environment management    |
| [stylix](https://github.com/danth/stylix)                     | System-wide theming            |
| [nixvim](https://github.com/nix-community/nixvim)             | Neovim configuration framework |
| [nvf](https://github.com/notashelf/nvf)                       | Alternative Neovim framework   |
| [jovian](https://github.com/Jovian-Experiments/Jovian-NixOS)  | Steam Deck / Jovian-NixOS      |
| [zen-browser](https://github.com/youwen5/zen-browser-flake)   | Zen Browser                    |
| [flake-utils](https://github.com/numtide/flake-utils)         | Flake utilities                |
| [dgop](https://github.com/AvengeMedia/dgop)                   | Custom package overlay         |

## License

MIT
