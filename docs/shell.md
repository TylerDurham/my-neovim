# Shell snippets

Source: [`shell.json`](../.config/my-neovim/snippets/shell.json) — filetypes `sh`, `bash`, `zsh`.

Type the prefix, then `<Tab>` / `<CR>` to expand. All of these assume Bash (arrays,
`[[ ]]`, `${var:0:1}`), not POSIX `sh`.

| Prefix | Description |
|---|---|
| [`shebang`](#shebang) | `#!/usr/bin/env bash` + strict mode |
| [`logging`](#logging) | Colored `info` / `debug` / `warn` / `error` helpers |
| [`usage`](#usage) | `usage()` that prints the script's own header comment block |
| [`getopts`](#getopts) | Short-flag parsing with `getopts` |
| [`args`](#args) | Hand-rolled parser: short, long, `--opt=value`, bundled flags |

---

## `shebang`

```sh
#!/usr/bin/env bash
set -euo pipefail
```

`set -euo pipefail` = exit on error, error on unset variables, and fail a pipeline if any
stage fails (not just the last one).

## `logging`

Minimal colored logging helpers. Everything goes to **stderr**, so `stdout` stays clean for
piping. Colors are only emitted when stderr is a TTY, and `debug` stays silent unless `DEBUG`
is set in the environment.

```sh
info "starting"     # [INFO ] starting     (blue)
debug "details"     # silent unless DEBUG is set   (purple)
warn "careful"      # [WARN ] careful      (yellow)
error "failed"      # [ERROR] failed       (red)
```

## `usage`

A `usage()` that reads the script's **own header comment block** — no line numbers, no
markers to keep in sync. It prints every comment line after the shebang and stops at the
first line that isn't a comment:

```sh
#!/usr/bin/env bash
# demo - a script that documents itself
#
# Usage: demo [-v] [-o DIR] FILE...
#
#   -v   verbose
#   -o   output dir
set -euo pipefail        # <- block ends here
```

Calling `usage` prints that block with the leading `# ` stripped. It uses
`${BASH_SOURCE[0]:-$0}` so it also works when the script is sourced. Because it reads the
file from disk, it will not work for a script piped into `bash` on stdin.

Drop-in replacement for the heredoc `usage()` in the `getopts` and `args` snippets.

## `getopts`

Flag parsing with the Bash builtin. Inserts a heredoc `usage()`, sensible defaults, and the
parse loop:

```sh
myscript -vn -f in.txt -o /tmp rest of the args
```

Boilerplate flags: `-h` help, `-v` verbose, `-n` dry run, `-f FILE`, `-o DIR`.

Notes:

- The leading `:` in `":hvnf:o:"` turns on **silent error handling**, so the `:` and `\?`
  cases print your messages instead of getopts' built-in ones.
- `shift $((OPTIND - 1))` at the end leaves the remaining positional args in `$@`.
- `getopts` handles bundling (`-vn`) and attached values (`-fin.txt`) for free, but it does
  **not** do long options — use `args` for those.

## `args`

Hand-rolled parser for when you want long flags. Supports:

| Form | Example |
|---|---|
| Short | `-v` |
| Long | `--verbose` |
| Long with value | `--file in.txt` or `--file=in.txt` |
| Bundled shorts | `-vn`, `-vnfin.txt`, `-vno/tmp` |
| End of options | `--` — everything after is positional |

Positionals are collected into `ARGS` and restored with `set -- "${ARGS[@]}"`, so `$@` and
`$1`, `$2`… behave normally afterwards.

```sh
myscript -vn --file=in.txt -o out one -- --not-a-flag two
# VERBOSE=1 DRY_RUN=1 FILE=in.txt OUTDIR=out
# $@ = one --not-a-flag two
```

Two maintenance notes:

- `need_arg "$@"` works because `$1` is the option being parsed and the count check covers
  the rest — so `--file ""` is still accepted as a deliberate empty value.
- The bundling case ends with `case "$flag" in f|o)` — that's the list of **short flags that
  take a value**. Add a new value-taking flag to the main parser and you must add its letter
  there too, or `-vXvalue` will treat `value` as more flags.
