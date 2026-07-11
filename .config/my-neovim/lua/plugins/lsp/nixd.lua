return {
  name = "nixd",
  -- nixd is not a Mason package; install via nix: nix-env -iA nixpkgs.nixd
  config = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = "import <nixpkgs> {}",
        },
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
  },
}
