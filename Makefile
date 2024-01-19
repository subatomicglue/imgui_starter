
# Makefile help: https://makefiletutorial.com/

EXE=app
IMGUI_DIR=imgui
SRCS=${IMGUI_DIR}/imgui.cpp ${IMGUI_DIR}/imgui_demo.cpp ${IMGUI_DIR}/imgui_draw.cpp ${IMGUI_DIR}/imgui_tables.cpp ${IMGUI_DIR}/imgui_widgets.cpp ${IMGUI_DIR}/misc/cpp/imgui_stdlib.cpp main.cpp

# backend flags for:  SDL2 + OpenGL3
SRCS += ${IMGUI_DIR}/backends/imgui_impl_sdl2.cpp ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
BACKEND_COMPILE_FLAGS=$(shell sdl2-config --cflags)
BACKEND_LINKER_FLAGS=$(shell sdl2-config --static-libs) $(shell sdl2-config --libs) -lGL

# compile and link flags
COMPILE_FLAGS=${BACKEND_COMPILE_FLAGS} -I${IMGUI_DIR} -I${IMGUI_DIR}/backends
LINKER_FLAGS=${BACKEND_LINKER_FLAGS}

all: ${IMGUI_DIR} ${EXE}
.PHONY: all

# build a list of objects
OBJS := $(SRCS:.cpp=.o)

# compile cpp
${OBJS}: %.o: %.cpp
	g++ ${COMPILE_FLAGS} -c $? -o $@

# compile app
${EXE}: ${OBJS}
	g++ $? -o ${EXE} ${LINKER_FLAGS}


# https://wiki.libsdl.org/SDL2/Installation
ubuntu-requisites:
	if [ "${shell sdl2-config --libs}" != "-lSDL2" ] sudo apt-get install libsdl2-dev

darwin-requisites:
	if [ "${shell sdl2-config --libs}" != "-lSDL2" ] brew install sdl2

# From Getting Started Guide: https://github.com/ocornut/imgui/wiki/Getting-Started
main.cpp:
	wget https://raw.githubusercontent.com/ocornut/imgui/master/examples/example_sdl2_opengl3/main.cpp -O main.cpp

# https://github.com/ocornut/imgui
${IMGUI_DIR}:
	git clone --branch "v1.90.1-docking" https://github.com/ocornut/imgui.git ${IMGUI_DIR}

clean:
	rm -f ${OBJS} ${EXE}

clobber:
	rm -rf ${IMGUI_DIR} main.cpp

help:
	@echo "all (default) | ${EXE} | clean | clobber"
	@echo "ubuntu-requisites | darwin-requisites"

