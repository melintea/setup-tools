#
#
#

all: test | .depends

# BOOSTDIR = ~/custom/boost_1_47_0
# CPPFLAGS = -I $(BOOSTDIR)

CPPFLAGS += -g -O2
CPPFLAGS += -std=c++0x
CPPFLAGS += -Wall

%.o: %.cpp
	g++ $(CPPFLAGS) -o $@ -c $<

%: %.o
	g++ $(CPPFLAGS) -o $@ $<

.depends: *.cpp
	g++ $(CPPFLAGS) -M $^ -o $@

clean:
	rm -rf test .depends

.PHONY: all clean
-include .depends

