# Animation Tools

![Cover - Animation Tools](https://raw.githubusercontent.com/signmotion/animation_tools/master/images/cover.webp)

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/signmotion/animation_tools/master/LICENSE)

The command-line easy-to-use and well-tested Dart's tools for processing animations.
Feel free to use it in your projects that are useful to the world.

## Supported formats

- [Spine](https://esotericsoftware.com)
- [You can add your own format]

## What can this tool do?

Run commands below into the terminal from the folder `animation_tools/bin/`.
Recommended: [Cmder](https://cmder.net).

### Work with animation folder

#### Copy animation folder

```bash
dart main.dart --source path/to/a --copy path/to/b
```

#### Scale animation folder

```bash
dart main.dart --source path/to/b --scale 0.75
```

### Working with concrete animation

#### Move and rename animation

```bash
dart main.dart --source path/to/b --move_animation 'idle idle_1'
```

#### Remove animation

```bash
dart main.dart --source path/to/b --remove_animation 'idle'
```

#### Leave only declared animations

```bash
dart main.dart --source path/to/b --leave_animations 'idle walk run shoot'
```

### Advanced use

Commands can be written in one line. For example, `copy and scale`:

```bash
dart main.dart --source path/to/a --copy path/to/b --scale 0.75
```

All commands and notes you can look with command:

```bash
dart main.dart --help
```

## Test

The examples you can see in the folder `test`.

```bash
dart test
```

## Project structure

### Entrypoint

- `bin` Entrypoint.
- `lib` Source code.
- `test` Unit tests with examples.

## Welcome

Requests and suggestions are warmly welcome.

This package is open-source, stable and well-tested. Development happens on
[GitHub](https://github.com/signmotion/animation_tools). Feel free to report issues
or create a pull-request there.

General questions are best asked on
[StackOverflow](https://stackoverflow.com/questions/tagged/animation_tools).
