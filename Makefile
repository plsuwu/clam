CC = emcc

RAYLIB_SRC = ./raylib/src

OUTDIR = build

CFLAGS = -Wall
EMFLAGS = -s USE_GLFW=3 -s ASYNCIFY --shell-file $(RAYLIB_SRC)/minshell.html -DPLATFORM_WEB

SRC = src/main.c

TARGET = $(OUTDIR)/game.html

all: $(TARGET)

$(TARGET): $(SRC)
	@mkdir -p $(OUTDIR)
	$(CC) -o $@ $(SRC) -I$(RAYLIB_SRC) $(RAYLIB_SRC)/libraylib.a $(EMFLAGS)

