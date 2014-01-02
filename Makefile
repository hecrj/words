all: words

words: src/*.cpp src/estimators/*.cpp src/hashing/*.cpp
	g++ src/main.cpp src/estimators/*.cpp src/hashing/*.cpp -O2 -o words

verbose: src/*.cpp src/estimators/*.cpp src/hashing/*.cpp
	g++ src/main.cpp src/estimators/*.cpp src/hashing/*.cpp -O2 -DVERBOSE -o words

clean:
	rm -f words
