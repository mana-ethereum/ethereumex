run: run.parity

run.parity:
	./bin/run_parity

setup: setup.parity

setup.parity:
	./bin/setup_parity

test::
	mix test
