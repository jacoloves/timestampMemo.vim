if exists('g:loaded_tsmemo')
    finish
endif

let g:loaded_tsmemo = 1

command! TimestampMemoList call timestampMemo#memolists() 

command! TimestampMemoCreate call timestampMemo#create_memo()
