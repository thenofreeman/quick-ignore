# Quick Ignore (git-ignore)

```bash
git ignore help
git ignore version
git ignore add zig-out/
git ignore add --template zig macos
git ignore remove .zig-out/
git ignore remove --template zig
git ignore list
git ignore list --all
git ignore list --unused
git ignore list --template=zig
git ignore list --rule="*.txt"
git ignore reset
git ignore --global .zig-out/
git ignore --force ...
git ignore check
git ignore refresh # re-add templates
```

## Installation

Integrate the command with your git:

```bash
git config --global alias.ignore '!sh -c "git-ignore \"$@\"" --'
```

## Usage

## Roadmap

## ..

```bash
# |-Templates-|
# zig
# macos
# vim
# ---zig.gitignore
# ....
# ....
# ---macos.gitignore
# ....
# ....
# ---vim.gitignore
# ....
# ....
# |-End-Templates-|

# .... Your personal ignores go here (recommended).
# ....
```
