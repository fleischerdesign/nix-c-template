CC       ?= gcc
CFLAGS   ?= -Isrc -Wall -Wextra -MMD -MP
LDFLAGS  ?=
LDLIBS   ?=

TARGET   ?= app
SRCDIR   ?= src
BUILD_MODE ?= release
BUILDDIR  ?= build/$(BUILD_MODE)

ifeq ($(BUILD_MODE),debug)
	CFLAGS += -Og -g3 -fsanitize=address,undefined
	LDFLAGS += -fsanitize=address,undefined
else
	CFLAGS += -O2
	LDFLAGS += -Wl,-s
endif

SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(SRCS:$(SRCDIR)/%.c=$(BUILDDIR)/%.o)
DEPS = $(OBJS:.o=.d)

.PHONY: all clean debug release compile_commands

all: $(BUILDDIR)/$(TARGET)

debug:
	$(MAKE) BUILD_MODE=debug

release:
	$(MAKE) BUILD_MODE=release

$(BUILDDIR)/$(TARGET): $(OBJS) | $(BUILDDIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(BUILDDIR)/%.o: $(SRCDIR)/%.c | $(BUILDDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILDDIR):
	mkdir -p $@

compile_commands.json:
	bear -- $(MAKE) BUILD_MODE=debug

clean:
	rm -rf $(BUILDDIR) compile_commands.json

-include $(DEPS)
