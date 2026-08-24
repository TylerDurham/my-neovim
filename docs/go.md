# Go snippets

Source: [`go.json`](../.config/my-neovim/snippets/go.json) — filetype `go`.

Type the prefix, then `<Tab>` / `<CR>` to expand. Basics (`func`, `for`, `struct`, plain
`if err != nil`) are deliberately **not** here — [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
already ships those. These are the longer, opinionated blocks that are tedious to retype.

| Prefix | Description |
|---|---|
| [`iferr`](#iferr) | Return a wrapped error |
| [`errsent`](#errsent) | Package-level sentinel error |
| [`ctxto`](#ctxto) | `context.WithTimeout` + `defer cancel()` |
| [`defclose`](#defclose) | Deferred `Close()` that reports its error |
| [`tt`](#tt) | Table-driven test with subtests |
| [`bench`](#bench) | Benchmark using `b.Loop()` |
| [`mainctx`](#mainctx) | `main` with signal-aware context and `run(ctx) error` |
| [`httpsrv`](#httpsrv) | HTTP server with graceful shutdown |
| [`workers`](#workers) | Fixed goroutine worker pool |

---

## `iferr`

```go
if err != nil {
	return fmt.Errorf("doing the thing: %w", err)
}
```

`%w` wraps rather than flattens, so `errors.Is` / `errors.As` still work up the stack. The
message is a tabstop — describe what *this* layer was doing, lowercase and without trailing
punctuation, per Go convention.

## `errsent`

```go
var ErrNotFound = errors.New("not found")
```

Sentinel error for comparison with `errors.Is(err, ErrNotFound)`. Pairs with `iferr`: wrap
it on the way up, match it at the top.

## `ctxto`

```go
ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
defer cancel()
```

The `defer cancel()` is not optional — skipping it leaks the timer until it fires.

## `defclose`

```go
defer func() {
	if cerr := f.Close(); cerr != nil && err == nil {
		err = cerr
	}
}()
```

For writers, where a failed `Close()` means the data may not have made it to disk. Requires
a **named** `err` return — `func write(...) (err error)` — otherwise it won't compile.
It only overwrites `err` when the function was otherwise succeeding, so the original failure
always wins.

## `tt`

Table-driven test with subtests, `t.Parallel()`, and `wantErr` handling. The function name is
mirrored across all its usages, so typing it once fills in the test name, the call, and both
failure messages.

```go
func TestFunc(t *testing.T) {
	tests := []struct {
		name    string
		in      string
		want    string
		wantErr bool
	}{
		{name: "base case", in: "", want: ""},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()
			...
		})
	}
}
```

`Fatalf` on the error mismatch (no point checking the value after that), `Errorf` on the
value mismatch (let the rest of the table run).

## `bench`

```go
func BenchmarkFunc(b *testing.B) {
	// setup goes here, before the loop
	for b.Loop() {
	}
}
```

`b.Loop()` needs **Go 1.24+**. It replaces the `for i := 0; i < b.N; i++` form and makes
`b.ResetTimer()` unnecessary — setup before the loop is excluded automatically, and the
compiler won't optimize the loop body away.

## `mainctx`

`package main` wired for clean shutdown:

```go
func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	if err := run(ctx); err != nil && !errors.Is(err, context.Canceled) {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}

func run(ctx context.Context) error {
	return nil
}
```

The `run(ctx) error` split exists so deferred cleanup actually runs — `os.Exit` in the middle
of your logic skips every `defer`. `context.Canceled` is filtered out because Ctrl-C is a
normal exit, not an error.

## `httpsrv`

`http.Server` started in a goroutine, with the caller blocked in a `select` on either a
startup error or `ctx.Done()`, at which point it calls `srv.Shutdown` with its own timeout.
Uses Go 1.22+ method-prefixed patterns (`"GET /healthz"`) and sets `ReadHeaderTimeout`
against slow-loris clients.

Designed to drop straight into the `run(ctx)` from `mainctx` — it assumes a `ctx` in scope
and a function that returns `error`.

## `workers`

Fixed pool of goroutines consuming a `jobs` channel:

```go
var wg sync.WaitGroup
for range runtime.NumCPU() {
	wg.Add(1)
	go func() {
		defer wg.Done()
		for job := range jobs {
			select {
			case results <- process(job):
			case <-ctx.Done():
				return
			}
		}
	}()
}

go func() {
	wg.Wait()
	close(results)
}()
```

The `select` on the send is what makes it cancellable — a plain `results <- ...` would block
forever if nobody is reading. The closer goroutine means the consumer can just `range
results` and stop when everything is done. Also assumes a `ctx` in scope.
