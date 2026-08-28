" Tokyo Night — pairs with ~/.config/alacritty/theme-dark.toml
" and ~/.config/tmux/theme-dark.conf.
"
" Re-sourced live on every GNOME colour-scheme flip (see the theme section of
" ~/.vim/vimrc), so everything here must be idempotent.

set background=dark
let g:tokyonight_style = 'night'          " bg0 #1a1b26, matching theme-dark.toml
colorscheme tokyonight

" Statusline pills, same palette as the tmux status bar. These must come after
" :colorscheme, which clears user-defined highlight groups.
highlight StlMode    guifg=#1a1b26 guibg=#7aa2f7 gui=bold
highlight StlModeSep guifg=#7aa2f7 guibg=#24283b gui=NONE
highlight StlFile    guifg=#a9b1d6 guibg=#24283b gui=NONE
highlight StlFileSep guifg=#24283b guibg=NONE    gui=NONE
highlight StlInfo    guifg=#565f89 guibg=NONE    gui=NONE
