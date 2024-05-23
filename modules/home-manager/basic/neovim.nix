{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.unstable.vimPlugins; [
      vim-better-whitespace
      vim-fugitive
      vim-startify
      vim-gitgutter
      vim-nix
      git-conflict-nvim
      bufferline-nvim
      lualine-nvim
      vscode-nvim
    ];
    extraConfig = ''
      " Plugins
      lua << END
        require('git-conflict').setup({})
        require("bufferline").setup({})
        require('lualine').setup({
            options = {
                theme = 'vscode',
            },
        })
      END
      " Indent
      set autoindent
      set smartindent
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set expandtab
      set smarttab
      " Search
      set ignorecase
      set incsearch
      set hlsearch
      set showmatch
      set gdefault
      " Appearance
      syntax on
      colorscheme vscode
      set number
      set wildmenu
      set termguicolors
      set laststatus=2
      set showcmd
      set showmode
      set guicursor=
      " Timing
      set updatetime=100
      set ttimeoutlen=10
      " Buffers
      set hidden
      set showtabline=2
      " Backups
      set noswapfile
      set nobackup
      set nowritebackup
      " Behaviour
      filetype plugin on
      set nocompatible
      set backspace=indent,eol,start
      set clipboard=unnamed,unnamedplus
      set visualbell
      set autoread
      set encoding=utf8
      set completeopt-=preview
      set nofixendofline
      " Change cursor based on mode
      set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175
      highlight Cursor gui=reverse
      " Key bindings
      nnoremap . :bn<CR>
      nnoremap , :bp<CR>
      nnoremap <C-c> :e ++enc=cp1250<CR>
      nnoremap <C-u> :e ++enc=utf-8<CR>
      " Trim whitespace
      nnoremap <F12> :%s/\s\+$//e<CR>
      " YAML
      autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
      " Ruby
      autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
      " Jenkinsfile
      au BufNewFile,BufRead Jenkinsfile setf groovy
      " Delete char, don't cut
      nnoremap x "_x
      nnoremap X "_X
      vnoremap x "_x
      vnoremap X "_X
      " Don't copy on paste
      vnoremap p "_dP
    '';
  };
}
