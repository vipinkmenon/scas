SRC=$(wildcard *.bsv)
OBJ=$(SRC:.bsv=.o)

all: $(OBJ)

%.o: %.bsv
	bsc -sim -u $<
	env CXX=g++ bsc -sim -o $@ -e mk`basename $< .bsv`Tb

run:
	./RollbackDesignWithoutState.o > result.withoutstate.withoutrollback.dat	
	./RollbackDesignWithoutState.o +rollback > result.withoutstate.rollback.dat	
	./RollbackDesignWithState.o > result.withstate.withoutrollback.dat	
	./RollbackDesignWithState.o +rollback > result.withstate.rollback.dat	

clean:
	rm *.o
	rm *.cxx
	rm *.ba
	rm *.bo
	rm *.h
	rm *.o.so
	rm *un~
