.PHONY: all build run experiments test clean

all: build

build:
	dune build

run:
	dune exec src/main.exe -- $(N)

experiments:
	dune exec src/experiments.exe

test:
	dune runtest

clean:
	dune clean

# make ... & make run N=...
%:
	@if echo "$@" | grep -Eq '^[0-9]+$$'; then \
	  dune exec src/main.exe -- "$@"; \
	else \
	  echo "Unknown target $@"; exit 1; \
	fi
