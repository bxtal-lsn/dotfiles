# Bxtal Dotfiles Setup

## Arch Linux Specific

```bash
sudo pacman -Syu gcc clang zig gopls golang stylua openssl pkg-config zoxide atuin eza starship neovim go-task jujutsu openssh bat
```

## Installations
[install stow](https://man.archlinux.org/man/stow.8)
```bash
sudo pacman -Syu stow
```

[install rust](https://doc.rust-lang.org/cargo/getting-started/installation.html)
```bash
curl https://sh.rustup.rs -sSf | sh
```

[install nushell](https://www.nushell.sh/book/installation.html)
```bash
cargo install nu --locked
```

[install starship](https://linuxconfig.org/how-to-install-and-configure-starship-on-linux#:~:text=There%20are%20many%20ways%20to%20install%20Starship%20on)
```bash
sudo pacman -Syu starship
```

---

[install neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

---

[install zoxide](https://github.com/ajeetdsouza/zoxide)
```bash
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

Setup zoxide on Nushell  
Add this to the end of your env file (find it by running $nu.env-path in Nushell):
```bash
zoxide init nushell | save -f ~/.zoxide.nu
```

Now, add this to the end of your config file (find it by running $nu.config-path in Nushell):


```bash
source ~/.zoxide.nu
```

---

[install atuin](https://docs.atuin.sh/guide/installation/)
```bash
cargo install atuin
```

run in Nushell
```bash
mkdir ~/.local/share/atuin/
atuin init nu | save ~/.local/share/atuin/init.nu
```

add to `config.nu`
```bash
source ~/.local/share/atuin/init.nu
```

