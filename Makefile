CXX = em++

OUTDIR = build
RAYLIB_SRC = ./raylib/src

EMFLAGS = -s USE_GLFW=3 -s ASYNCIFY --shell-file $(RAYLIB_SRC)/minshell.html -DPLATFORM_WEB
CXXFLAGS = -Wall $(EMFLAGS) -std=c++23

SRCS = src/main.cpp 
TARGET = $(OUTDIR)/game.html

all: $(TARGET)

$(TARGET): $(SRCS)
	@mkdir -p $(OUTDIR)
	$(CXX) -o $@ $(SRCS) -I$(RAYLIB_SRC) $(RAYLIB_SRC)/libraylib.a $(CXXFLAGS)

