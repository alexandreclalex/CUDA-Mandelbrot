CC = gcc
CFLAGS = -g -Wall
TARGET = mandelbrot

all: $(TARGET)

$(TARGET): $(main.c)
	$(CC) $(CFLAGS) -o $(TARGET) -lm main.c

clean:
	rm $(TARGET)