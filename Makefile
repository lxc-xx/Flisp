all: flispc
	raco distribute . ./src/flispc

flispc: ./src/flispc.rkt
	raco exe ./src/flispc.rkt

clean:
	rm bin/*
	rm -r lib/*
	rm ./src/flispc
