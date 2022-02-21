# Animation Tools

The command-line tools for processing animations.

## Supported formats

* Spine

You can add any animation format you want.
Or ask me to do it.

## What can this tool do?

Run commands below into the terminal from the folder `animation_tools/bin/`.
For example, [Cmder](https://cmder.net).

### Work with animation folder

#### Copy animation folder
`dart main.dart --source path/to/a --copy path/to/b`

#### Scale animation folder
`dart main.dart --source path/to/b --scale 0.75`

### Working with concrete animation

#### Move and rename animation
`dart main.dart --source path/to/b --move_animation 'idle idle_1'`

#### Remove animation
`dart main.dart --source path/to/b --remove_animation 'idle'`

#### Leave only declared animations
`dart main.dart --source path/to/b --leave_animations 'idle walk run shoot'`

Commands can be written in one line. For example, "copy and scale":
`dart main.dart --source path/to/a --copy path/to/b --scale 0.75`

All commands and notes you can look with command:
`dart main.dart --help`

## Test

All commands and examples you can see in the folder `test`.

### How run tests
`dart test`

## Project structure

### Entrypoint

`bin/`

### Library code

`lib/`

### Example unit test

`test/`
