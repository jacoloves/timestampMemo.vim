# timestampMemo.vim
You can use this when you want to take notes while running vim.

# Requirements
・It works with both Vim and NeoVim.   
・It has the following features.
  1. Memo list view
  2. Memo creation process
  3. Memo deletion process
  4. Memo renaming process

# Installation
This is an example of installation using vim-plug.
```
Plug 'jacoloves/timestampMemo.vim'
```

# Usage
## :TimestampMemoCreate   
You can create a file with today's date.   
If you want a new file with today's date, just rename the existing file.

## :TimestampMemoList   
Outputs the file list to a new buffer.   
The file deletion and rename deletion processes also work in this buffer.

## Memo deletion process
Press the D key on the name of the file you want to delete in the buffer to activate the deletion process.

![Memo deletion process](./giffile/timestampmemo_delete.gif)

## Memo renaming process
Press the R key on the name of the file you want to rename in the buffer to activate the renaming process.

![Memo renaming process](./giffile/timestampmemo_rename.gif)

# License
Distributed under MIT License. See LICENSE.