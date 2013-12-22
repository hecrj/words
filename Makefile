all: words

words: src/main.cpp src/estimators/*.cpp
	g++ -O2 -o words src/main.cpp src/estimators/*.cpp

clean:
	rm -f words
