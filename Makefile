all:  usbdmx_example usbdmx_example_static simple_example simple_example_static libusbdmx.so
	echo "" ; head -n 14 README.txt

CC=gcc
CXX=g++
COBJS=hid.o usbdmx.o
CPPOBJS=
OBJS=$(COBJS) $(CPPOBJS)
CFLAGS+=-Wall -g -c -fpic -pthread
LIBS=`pkg-config libudev --libs`

usbdmx_example: usbdmx_example.cpp libusbdmx.so libusbdmx.a
	g++ -L. -lusbdmx -Wall -o usbdmx_example usbdmx_example.cpp

usbdmx_example_static: usbdmx_example.cpp libusbdmx.so libusbdmx.a
	g++ $(OBJS) $(LIBS) usbdmx_example.cpp -o usbdmx_example_static

simple_example: simple_example.c libusbdmx.so libusbdmx.a
	gcc -L. -lusbdmx -Wall -o simple_example simple_example.c

simple_example_static: simple_example.c libusbdmx.so libusbdmx.a
	gcc $(OBJS) $(LIBS) simple_example.c -o simple_example_static

libusbdmx.so: $(OBJS)
	$(CC) $(LIBS) $(OBJS) -shared -o libusbdmx.so

libusbdmx.a: usbdmx.o
	ar rcs libusbdmx.a usbdmx.o

$(COBJS): %.o: %.c
	$(CC) $(CFLAGS) $< -o $@

$(CPPOBJS): %.o: %.cpp
	$(CXX) $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJS) usbdmx_example usbdmx_example_static libusbdmx.so libusbdmx.a

.PHONY: clean