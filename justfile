MACOS_GHOSTTY_CONFIG := 'Library/Application\ Support/com.mitchellh.ghostty/config.ghostty'

default:
    @just --list

link: lazygit ghostty git fd ripgrep

lazygit:
    ln -sfn  {{ justfile_directory() }}/lazygit ~/.config

[linux]
ghostty:
    ln -sfn  {{ justfile_directory() }}/ghostty ~/.config

[macos]
ghostty:
    ln -sfn  {{ justfile_directory() }}/ghostty ~/.config
    ln -sf  {{ justfile_directory() }}/{{ MACOS_GHOSTTY_CONFIG }} ~/{{ MACOS_GHOSTTY_CONFIG }}

git:
    ln -sfn {{ justfile_directory() }}/gitconfig ~/.gitconfig

fd:
    ln -sfn {{ justfile_directory() }}/fd ~/.config

ripgrep:
    ln -sfn {{ justfile_directory() }}/.ripgrep ~/
