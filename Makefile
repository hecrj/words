all: words

words: src/*.cpp src/estimators/*.cpp
	g++ -O2 -o words src/*.cpp src/estimators/*.cpp

clean:
	rm -f words
