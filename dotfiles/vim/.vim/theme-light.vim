" Catppuccin Latte — pairs with ~/.config/alacritty/theme-light.toml
" and ~/.config/tmux/theme-light.conf.
"
" Re-sourced live on every GNOME colour-scheme flip (see the theme section of
" ~/.vim/vimrc), so everything here must be idempotent.

set background=light
colorscheme catppuccin_latte

" Statusline pills, same palette as the tmux status bar. These must come after
" :colorscheme, which clears user-defined highlight groups.
highlight StlMode    guifg=#eff1f5 guibg=#1e66f5 gui=bold
highlight StlModeSep guifg=#1e66f5 guibg=#ccd0da gui=NONE
highlight StlFile    guifg=#4c4f69 guibg=#ccd0da gui=NONE
highlight StlFileSep guifg=#ccd0da guibg=NONE    gui=NONE
highlight StlInfo    guifg=#8c8fa1 guibg=NONE    gui=NONE
