{ pkgs }:

pkgs.vim-full.customize {
  name = "vim";
  vimrcConfig.packages.myVimPackage = {
    start = with pkgs.vimPlugins; [
      # Appearance & UI
      vim-airline
      vim-airline-themes
      vim-colors-solarized
      indentLine

      # Navigation & Structure
      nerdtree
      tagbar
      fzf-vim

      # IDE & LSP Tools
      coc-nvim
      coc-snippets
      vim-autoformat
      vim-floaterm

      # Editing Helpers
      vim-surround
      vim-commentary
      auto-pairs
      vim-polyglot

      # Git Integration
      vim-fugitive
      vim-gitgutter
    ];
  };

  vimrcConfig.customRC = ''
    " ==============================================================================
    " 1. ENVIRONMENT & INTEGRATIONS
    " ==============================================================================
    let g:coc_node_path = '${pkgs.nodejs}/bin/node'
    let g:tagbar_ctags_bin = '${pkgs.universal-ctags}/bin/ctags'

    let g:clipboard = {
      \   'name': 'wl-clipboard',
      \   'copy': {
      \      '+': 'wl-copy --foreground --type text/plain',
      \      '*': 'wl-copy --foreground --primary --type text/plain',
      \    },
      \   'paste': {
      \      '+': 'wl-paste --no-newline',
      \      '*': 'wl-paste --no-newline --primary',
      \    },
      \   'cache_enabled': 0,
      \ }

    " ==============================================================================
    " 2. GRUNDEINSTELLUNGEN
    " ==============================================================================
    syntax on
    set number
    set norelativenumber
    set termguicolors
    set encoding=utf-8
    set shiftwidth=2
    set tabstop=2
    set softtabstop=2
    set expandtab
    set mouse=a
    set hidden
    set clipboard=unnamedplus
    set updatetime=300
    set signcolumn=yes

    " Leader Key auf Leertaste setzen
    let mapleader = " "

    " ==============================================================================
    " 3. THEME & AIRLINE
    " ==============================================================================
    set background=dark
   " let g:solarized_termcolors = 256
   " let g:solarized_use16 = 1
   " colorscheme solarized

  "  let g:airline_theme = "solarized"
   " let g:airline_powerline_fonts = 1

    " ==============================================================================
    " 4. KEYBINDINGS & MAPPINGS
    " ==============================================================================
    " Strg + Backspace zum Löschen von Wörtern
    noremap! <C-H> <C-W>
    noremap! <C-BS> <C-W>

    " --- NERDTree ---
    nnoremap <C-n> :NERDTreeToggle<CR>

    " --- Tagbar (Structure View / Code Outline) ---
    nnoremap <F8> :TagbarToggle<CR>
    let g:tagbar_autofocus = 1
    let g:tagbar_width = 30

    " --- Floating Terminal (F12) ---
    let g:floaterm_keymap_toggle = '<F12>'
    let g:floaterm_width = 0.8
    let g:floaterm_height = 0.8
    let g:floaterm_title = ' Terminal ($1/$2) '

    " --- FZF & Search (Dateien & Projektweit) ---
    nnoremap <leader>ff :Files<CR>
    nnoremap <leader>fg :GFiles<CR>
    nnoremap <leader>fw :Rg<CR>
    nnoremap <leader>fc :Rg <C-R><C-W><CR>

    " --- Autoformat (F3) ---
    nnoremap <F3> :Autoformat<CR>

    " --- Git Commands (Fugitive) ---
    nnoremap <leader>gs :Git<CR>
    nnoremap <leader>gb :Git blame<CR>
    nnoremap <leader>gd :Gdiffsplit<CR>
    nnoremap <leader>gl :Git log<CR>

    " ==============================================================================
    " 5. COC.NVIM (LSP / COMPLETION / NAVIGATION)
    " ==============================================================================
    " Tab-Autovervollständigung
    inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
    inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
    inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

    " Code-Navigation
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Hover-Dokumentation
    nnoremap <silent> K :call ShowDocumentation()<CR>
    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    " Refactoring & QuickFix
    nmap <leader>rn <Plug>(coc-rename)
    nmap <leader>ca <Plug>(coc-codeaction-cursor)

    " Diagnostics (Fehler & Warnungen)
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nnoremap <silent><nowait> <leader>cd :CocList diagnostics<CR>
    nnoremap <silent><nowait> <leader>co :CocOutline<CR>

    " ==============================================================================
    " 6. AUTOCOMMANDS
    " ==============================================================================
    autocmd VimEnter * NERDTree | wincmd p
    autocmd BufEnter * if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() | quit | endif

    " ==============================================================================
    " 7. CUSTOM TABLINE / INHALTSVERZEICHNIS-LEISTE
    " ==============================================================================
    set showtabline=2

    let g:kasten_default = "Kein Inhaltsverzeichnis"
    let b:kasten_scroll_offset = 0

    function! AktuellerKastenText()
      let l:text = get(b:, "mein_kasten_text", g:kasten_default)
      if !exists("b:kasten_scroll_offset") | let b:kasten_scroll_offset = 0 | endif

      if strlen(l:text) <= 100
        return l:text
      endif

      let l:sichtbar = strpart(l:text, b:kasten_scroll_offset, 100)
      let l:prefix = b:kasten_scroll_offset > 0 ? "< " : ""
      let l:suffix = (b:kasten_scroll_offset + 100) < strlen(l:text) ? " >" : ""

      return l:prefix . l:sichtbar . l:suffix
    endfunction

    function! KastenScrollRechts()
      let l:text = get(b:, "mein_kasten_text", g:kasten_default)
      if b:kasten_scroll_offset + 100 < strlen(l:text)
        let b:kasten_scroll_offset += 10
        redrawtabline
      endif
    endfunction

    function! KastenScrollLinks()
      if b:kasten_scroll_offset > 0
        let b:kasten_scroll_offset = max([0, b:kasten_scroll_offset - 10])
        redrawtabline
      endif
    endfunction

    function! KastenHinzufuegen(neuer_text)
      if !exists("b:mein_kasten_text") || b:mein_kasten_text == g:kasten_default
        let b:mein_kasten_text = a:neuer_text
      else
        let b:mein_kasten_text = b:mein_kasten_text . " | " . a:neuer_text
      endif
      let b:kasten_scroll_offset = 0
      redrawtabline
    endfunction

    command! -nargs=+ Kasten call KastenHinzufuegen(<q-args>)
    command! KastenReset unlet! b:mein_kasten_text | let b:kasten_scroll_offset = 0 | redrawtabline

    nnoremap + :call KastenScrollRechts()<CR>
    nnoremap - :call KastenScrollLinks()<CR>

    " Automatisches Speichern & Laden der Tabline-Notiz
    autocmd BufReadPost * call KastenLaden()
    function! KastenLaden()
      let l:letzte_zeilen = getline(max([1, line("$")-4]), line("$"))
      for l:zeile in l:letzte_zeilen
        let l:match = matchlist(l:zeile, "VIM_KASTEN:\\s*\\(.*\\)")
        if !empty(l:match) && !empty(l:match[1])
          let b:mein_kasten_text = l:match[1]
          let b:kasten_scroll_offset = 0
          redrawtabline
          break
        endif
      endfor
    endfunction

    autocmd BufWritePre * call KastenSpeichern()
    function! KastenSpeichern()
      if exists("b:mein_kasten_text") && b:mein_kasten_text != g:kasten_default
        let l:comment = substitute(&commentstring, "%s", "", "")
        if empty(l:comment) | let l:comment = "# " | endif
        let l:neue_speicherzeile = trim(l:comment) . " VIM_KASTEN: " . b:mein_kasten_text

        let l:line_num = line("$")
        while l:line_num > max([1, line("$")-3])
          if getline(l:line_num) =~ "VIM_KASTEN:"
            call setline(l:line_num, l:neue_speicherzeile)
            return
          endif
          let l:line_num -= 1
        endwhile
        call append(line("$"), l:neue_speicherzeile)
      endif
    endfunction

    set tabline=%#Visual#\ \|\ Inhaltsverzeichnis:\ %{AktuellerKastenText()}\ \|\
  '';
}
