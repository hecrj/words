all: words

words: src/*.cpp src/estimators/*.cpp src/hashing/*.cpp
	g++ -O2 -o words src/main.cpp src/estimators/*.cpp src/hashing/*.cpp

clean:
	rm -f words
