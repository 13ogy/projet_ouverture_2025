.PHONY: all build run clean

all: build

build:
	dune build

run:
	dune exec src/main.exe

clean:
	dune clean