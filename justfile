default:
    @just --list

link: lazygit ghostty git

lazygit:
    ln -sfn  {{ justfile_directory() }}/lazygit ~/.config

ghostty:
    ln -sfn  {{ justfile_directory() }}/ghostty ~/.config

git:
    ln -sfn {{ justfile_directory() }}/gitconfig ~/.gitconfig
