CC ?= gcc
CFLAGS ?= -Wall -Wextra -O2
SRC = src/main.c
OUT_DIR = build/release
TARGET = $(OUT_DIR)/app

all: $(TARGET)

$(TARGET): $(SRC)
	@mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf build

.PHONY: all clean
