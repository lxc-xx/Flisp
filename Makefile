all: flispc
	raco distribute . ./src/flispc ./src/make-app
	rm ./src/flispc
	rm ./src/make-app


flispc: ./src/flispc.rkt
	raco exe ./src/flispc.rkt
	raco exe ./src/make-app.rkt

clean:
	rm -r bin
	rm -r lib
