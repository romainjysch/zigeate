# zigeate

A minimalist alternative to `zig init`.

## Features

- Creates a new Zig project with a standard and minimalist structure;
- Generates `src/main.zig`, `build.zig`, `README.md`, and `.gitignore` automatically;
- Fails gracefully if the target directory already exists.

## Installation

1. Clone this repository:
```
git clone https://github.com/romainjysch/zigeate.git
```

2. Build the project:
```
cd zigeate
zig build
```

3. Copy the binary:
```
sudo cp zig-out/bin/zigeate /usr/local/bin/
```

## Usage

Only one command:

```
zigeate [project_name]
```

Example:
```
zigeate my_new_project
```

Print help:
```
zigeate -h
zigeate --help
```

## License

MIT