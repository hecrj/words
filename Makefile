all: words

words: src/*.cpp src/estimators/*.cpp
	g++ -O2 -o words src/*.cpp src/estimators/*.cpp src/hashing/*.cpp -DVERBOSE

clean:
	rm -f words
