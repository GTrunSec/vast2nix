runner := "nix run "
builder := "nix build "

# [ "x86-64-darwin" ]
system := ".#x86_64-linux"
doc := ".vast.entrypoints.doc"
packages := ".packages."
config := ".user.entrypoints.config lock"
zeek := ""

#help
doc flag:
    {{runner}}{{system}}{{doc}} {{flag}}

build cell name:
    {{builder}}{{system}}.{{cell}}{{packages}}{{name}}
