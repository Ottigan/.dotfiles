MACOS_GHOSTTY_CONFIG := 'Library/Application\ Support/com.mitchellh.ghostty/config.ghostty'

default:
    @just --list

link: lazygit ghostty git

lazygit:
    ln -sfn  {{ justfile_directory() }}/lazygit ~/.config

[linux]
ghostty:
    ln -sfn  {{ justfile_directory() }}/ghostty ~/.config

[macos]
ghostty:
    ln -sfn  {{ justfile_directory() }}/ghostty ~/.config
    ln -s  {{ justfile_directory() }}/{{ MACOS_GHOSTTY_CONFIG }} ~/{{ MACOS_GHOSTTY_CONFIG }}

git:
    ln -sfn {{ justfile_directory() }}/gitconfig ~/.gitconfig
