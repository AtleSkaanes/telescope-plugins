# telescope-plugins

Telescope-plugins is a small [telescope](https://github.com/nvim-telescope/telescope.nvim) extension,
that lets you list all of your installed [packer](https://github.com/wbthomason/packer.nvim) plugins.
You can fuzzy search and select a plugin, to open the github repo in your browser.

This is the first nvim plugin I have made, so expect errors.

### Dependencies
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [packer.nvim](https://github.com/wbthomason/packer.nvim)


### Installation
Currently, this only works with packer
```vim
use 'AtleSkaanes/telescope-plugins'
```

### Usage
When it is installed, you need to bind the extension to telescope
```vim
require('telescope').load_extension('telescopeplugins')
```

Optionally, you can bind it to a custom keymapping (There is none by default).
Here is an example of a remap:
```vim
vim.keymap.set('n', '<leader>p', "<Cmd>lua require('telescope').extensions.telescopeplugins.ListPlugins()<CR>", {}))
```

### Features
- [x] List plugins
- [x] Packer support
- [ ] Plug support
- [ ] Dein support
- [x] Lazy.nvim support
