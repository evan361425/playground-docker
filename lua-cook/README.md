# Lua cook

It use [Busted](https://lunarmodules.github.io/busted/) to test and
[LuaFormatter](https://github.com/Koihik/LuaFormatter) to lint lua scripts!

-   [LuaFormatter](https://github.com/Koihik/LuaFormatter): [82756f](https://github.com/Koihik/LuaFormatter/commit/82756f482d20b85cda6c4c338f6f11438eae8bc4)
-   [Busted](https://lunarmodules.github.io/busted/): [v2.1.1](https://github.com/lunarmodules/busted/releases/tag/v2.1.1)

```bash
docker run --rm -t -v "$PWD:/data" shuehchoulu/lua-cook:${VERSION} lua-project.json
```

Available in [Docker Hub](https://hub.docker.com/r/shuehchoulu/lua-cook) and [GitHub Packages](https://github.com/evan361425/playground-docker/pkgs/container/lua-cook)

## Configuration

You must give it configuration JSON file, for example `lua-project.json`:

```jsonc
{
  "files": ["src", "test"], // folders include lua scripts
  "test": { // configuration for testing
    "folders": ["test"], // needed folders
    "pattern": ".spec",
    "helper": "test/helpers.lua",
    "output": "gtest",
    "verbose": true
  },
  "format": { // configuration for formatting/linting
    "column-limit": 120,
    "single-quote-to-double-quote": true,
    "keep-simple-control-block-one-line": true,
    "no-keep-simple-function-one-line": true,
    "spaces-inside-table-braces": true
  }
}
```

Excepts commented fields, all the fields are directly pass to the dependency(LuaFormatter/Busted).

## Specific action

In additionally, you can do specific action by passing second argument.

### Test

```bash
docker run --rm -t -v "$PWD:/data" shuehchoulu/lua-cook:${VERSION} lua-project.json test --t_verbose
```

You can pass custom argument by command line without configuration file.
The only different with Busted was all argument must prefix with `t_`, for example:

-   `--t_verbose`
-   `--t_pattern=_spec`

### Lint

Custom argument must prefix with `f_`.

```bash
$ docker run --rm -t -v "$PWD:/data" shuehchoulu/lua-cook:${VERSION} lua-project.json format --f_check
===== Formatting =====
... config data ...
formatting: /data/src/main.lua
    === Success ===
```

-   [`--check`](https://github.com/Koihik/LuaFormatter#usage) Non-zero return if formatting is needed.
**This is default setting**.

### Format

Custom argument must prefix with `f_`.

```bash
docker run --rm -t -v "$PWD:/data" shuehchoulu/lua-cook:${VERSION} lua-project.json format --f_in-place
===== Formatting =====
... config data ...
formatting: /data/src/main.lua
    === Success ===
```

-   [`--in-place`](https://github.com/Koihik/LuaFormatter#usage) Reformats in-place
