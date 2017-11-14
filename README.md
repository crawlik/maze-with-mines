# Starfleet Fun

# Prerequisites

Ruby 2.3 & bundler gem. Please refer to
https://www.ruby-lang.org/en/documentation/installation/ for installation
instructions for your OS

# Bootstrapping

```bash
bundle install
```

# Running tests

```bash
rspec spec
```

# Usage help

```bash
$ ruby emazeme
Commands:
  emazeme help [COMMAND]    # Describe available commands or one specific command
  emazeme solve FILE LIVES  # Solve mazes
```

# Example

```bash
$ ruby emazeme solve mazes/maze.0
------------------------------
From 7:[1, 2] to 0:[0, 0]
Shortest path: [7, 4, 1, 0]
Shortest path directions: ["up", "up", "left"]
Mine hits: 1. Mine positions: [[1, 1]]

$ ruby emazeme solve mazes/mazes.txt
```
