{ pkgs }:

pkgs.vim-full.customize {
    name = "vim";
    vimrcConfig.packages.myVimPackage = {
      start = with pkgs.vimPlugins; [
        vim-airline
        vim-airline-themes
        nerdtree
        vim-fugitive
        vim-gitgutter
        vim-surround
        vim-commentary
        fzf-vim
        vim-polyglot
        indentLine
        auto-pairs
        vim-autoformat
        vim-colors-solarized
      ];
    };
    vimrcConfig.customRC = ''
      syntax on
      set number
      set relativenumber
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

      " Solarized Dark
      set background=dark
      let g:solarized_termcolors = 256
      let g:solarized_use16 = 1
      colorscheme solarized

      " Airline
      let g:airline_theme = "solarized"
      let g:airline_powerline_fonts = 1

      " Leader
      let mapleader = " "

      " NERDTree
      nnoremap <C-n> :NERDTreeToggle<CR>

      "strg backspace
      noremap! <C-H> <C-W>
      noremap! <C-BS> <C-W>

      " File search
      nnoremap <leader>ff :Files<CR>
      nnoremap <leader>fg :GFiles<CR>

      " Autoformat
      nnoremap <F3> :Autoformat<CR>

      " nerdtree"
      autocmd VimEnter * NERDTree | wincmd p

"" --- ALLES FÜR DIE INHALTSVERZEICHNIS-LEISTE ---
      set showtabline=2

      " Globale Variablen für den Kasten und das Ticker-Scrolling
      let g:kasten_default = "Kein Inhaltsverzeichnis"
      let b:kasten_scroll_offset = 0

      " Funktion, die den sichtbaren Ausschnitt für die Leiste berechnet
      function! AktuellerKastenText()
        let l:text = get(b:, "mein_kasten_text", g:kasten_default)
        if !exists("b:kasten_scroll_offset") | let b:kasten_scroll_offset = 0 | endif

        " Wenn der Text kurz genug ist, zeige ihn einfach komplett
        if strlen(l:text) <= 100
          return l:text
        endif

        " Berechne das sichtbare Fenster (max. 100 Zeichen breit)
        let l:sichtbar = strpart(l:text, b:kasten_scroll_offset, 100)

        " Visuelle Indikatoren (+ / -), ob links oder rechts noch Text kommt
        let l:prefix = b:kasten_scroll_offset > 0 ? "< " : ""
        let l:suffix = (b:kasten_scroll_offset + 100) < strlen(l:text) ? " >" : ""

        return l:prefix . l:sichtbar . l:suffix
      endfunction

      " Funktionen zum Scrollen des Inhaltsverzeichnisses
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

      " Funktion zum Hinzufügen von Kapiteln
      function! KastenHinzufuegen(neuer_text)
        if !exists("b:mein_kasten_text") || b:mein_kasten_text == g:kasten_default
          let b:mein_kasten_text = a:neuer_text
        else
          let b:mein_kasten_text = b:mein_kasten_text . " | " . a:neuer_text
        endif
        let b:kasten_scroll_offset = 0 " Reset Scroll bei neuem Eintrag
        redrawtabline
      endfunction

      " Befehle für den User
      command! -nargs=+ Kasten call KastenHinzufuegen(<q-args>)
      command! KastenReset unlet! b:mein_kasten_text | let b:kasten_scroll_offset = 0 | redrawtabline

      " Hotkeys zum bequemen Scrollen der oberen Leiste im Normal-Mode
      nnoremap + :call KastenScrollRechts()<CR>
      nnoremap - :call KastenScrollLinks()<CR>

      " --- AUTOMATISCHES SPEICHERN & LADEN ---
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

      " Das saubere, einzeilige Layout (ohne Steuerzeichen-Fehler)
      set tabline=%#Visual#\ \|\ Inhaltsverzeichnis:\ %{AktuellerKastenText()}\ \|\


    '';
  }
