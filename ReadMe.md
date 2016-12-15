libyaml-parser-emitter
======================

Parser and Emitter CLI tools for libyaml

# Try it Now with Docker:

```
curl -s https://raw.githubusercontent.com/yaml/libyaml-parser/master/test/example-2.27-invoice.yaml | docker run -iv $PWD:/docker yamlio/libyaml-parser-emitter libyaml
```

# Synopsis

```
git clone https://github.com/yamlio/libyaml-parser-emitter
cd libyaml-parser-emitter
make build
make test
```

# Usage

Print parse events for a YAML file (or stdin):
```
./libyaml-parser file.yaml
./libyaml-parser < file.yaml
cat file.yaml | ./libyaml-parser
```

Print the YAML for a libyaml-parser events file (or stdin):
```
./libyaml-emitter file.events
./libyaml-emitter < file.events
cat file.events | ./libyaml-emitter
```

## With Docker:

YAML -> Events:
```
alias my-yaml-parser='docker run -iv $PWD:/docker yamlio/libyaml-parser-emitter libyaml-parser'
my-yaml-parser file.yaml
my-yaml-parser < file.yaml
cat file.yaml | my-yaml-parser
```

Events -> YAML:
```
alias my-yaml-emitter='docker run -iv $PWD:/docker yamlio/libyaml-parser-emitter libyaml-emitter'
my-yaml-emitter file.events
my-yaml-emitter < file.events
cat file.yaml | my-yaml-emitter
```

# Build

## Native Build

```
export LIBYAML_DIR=/path/to/libyaml   # Optional
make build
```

## Docker Image Build

```
DOCKER_USER=yamlio make docker
```
