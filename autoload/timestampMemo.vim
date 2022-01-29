let s:time = strftime("%Y%m%d_%T")
let s:sep = fnamemodify('.', ':p')[-1:]

" nvimにはreaddir()は存在しないのでglob()を使用して代替する。
if exists('*readdir')
    let s:readdir = function('readdir')
else
    function! s:readdir(dir) abort
        return map(glob(a:dir . s:sep . '*', 1, 1), 'fnamemodify(v:val, ":t")')
    endfunction
endif


function! timestampMemo#create_memo() abort
    " 日付を成形する。
    let filename = substitute(s:time, ":", "", "g") . "_memo.txt"
    " redir()でメモファイルを生成
    execute "redir > " . join([g:timestamp_save_path, filename], s:sep)
    execute "redir END"

    " 生成したメモファイルを開く
    execute "tabedit " . join([g:timestamp_save_path, filename], s:sep)
    echo 'memo: created'
endfunction

" メモファイル編集処理
function! timestampMemo#edit_memo(file) abort
    " メモファイルを開く
    execute "tabedit " . join([g:timestamp_save_path, a:file], s:sep)
endfunction

" エラーメッセージ（赤）を出力する関数
function! s:echo_err(msg) abort
    echohl ErrorMsg
    echomsg 'timstampMemo.vim:' a:msg
    echohl None
endfunction

function! s:memofiles() abort
    " グローバル辞書変数のキー値から値を取得する。
    let memofiles_path = get(g:, 'timestamp_save_path', '')

    " g:timestamp_save_pathが設定されていない場合はエラーメッセージを出力して空のリストを返す。 
    if memofiles_path is# ''
        call s:echo_err('g:timestamp_save_path is empty')
        return []
    endif

    " 変数を展開して再度memofiles_pathを定義する。
    let memofiles_path = expand(memofiles_path) 
    " memoという引数を受けとり、そのファイルがディレクトリでなければ1を返すLambda。
    let Filter = { memo -> !isdirectory(memofiles_path . s:sep . memo) }
   
    return filter(s:readdir(memofiles_path), Filter)
endfunction


" メモ一覧を表示するバッファ名
let s:memo_list_buffer = 'TIMESTAMPMEMO_LIST'

function! timestampMemo#memolists() abort
    let memos = s:memofiles()
    if empty(memos)
        return
    endif

    " バッファが存在している場合
    if bufexists(s:memo_list_buffer)
        " バッファがウィンドウに表示されている場合は`win_gotoid`でウィンドウに移動する
        let winid = bufwinid(s:memo_list_buffer)
        if winid isnot# -1
            call win_gotoid(winid)
        " バッファがウィンドウに表示されていない場合は`sbuffer`で新しいウィンドウを作成してバッファを開く
        else
            execute 'sbuffer' s:memo_list_buffer
        endif
    else
        " バッファが存在していない場合は`new`で新しいバッファを作成する
        execute 'new' s:memo_list_buffer
        
        " バッファの種類を指定する。
        " ユーザーが書き込むことがないバッファなので`nofile`を設定する
        set buftype=nofile

        " 1. メモ一覧のバッファで`q`を押下するとバッファを破棄
        " 2. `Enter`でメモを開く
        " の2つのキーマッピングを定義する
        nnoremap <silent> <buffer>
                    \ <Plug>(memosession-close)
                    \ :<C-u>bwipeout!<CR> 

        nnoremap <silent> <buffer>
                    \ <Plug>(memo-open)
                    \ :<C-u>call timestampMemo#edit_memo(trim(getline('.')))<CR>
        
        " <Plug>マップをキーにマッピングする
        nmap <buffer> q <Plug>(memosession-close)
        nmap <buffer> <CR> <Plug>(memo-open)
    endif
   
    " メモファイルを表示する一時バッファのテキストをすb手削除して、取得したファイル一覧をバッファに挿入する。
    %delete _
    call setline(1, memos)
endfunction
