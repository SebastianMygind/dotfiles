if status is-interactive
# Commands to run in interactive sessions can go here
    if type -q keychain
        SHELL=(which fish) keychain --quiet --eval id_ed25519 | source
    end
end

mise activate fish | source

fish_add_path ~/.local/bin/
fish_add_path ~/.cargo/bin/
