# Source, Executable, Library Defines.
LIB_SRC_DIR	 = src
OBJ_DIR      = obj
LIB_DIR      = lib
LIB_SRC     := $(subst $(LIB_SRC_DIR)/,, $(shell find $(LIB_SRC_DIR) -maxdepth 1 -name '*.c')) 
LIB_OBJ      = $(LIB_SRC:.c=.o)
ALIB         = libnetapix.a
             
# Compiler, Include, Linker Defines.
CC           = gcc
LIB_INCLUDE  = -I./include/ -I./src/
LIB_CFLAGS   = $(LIB_INCLUDE) -w

all: lib

# Compile and Assemble C Source Files into Object Files.
%.o: $(LIB_SRC_DIR)/%.c
	$(CC) $(LIB_CFLAGS) -c $< -o $(OBJ_DIR)/$@

# Assemble static library from Object Files.
$(ALIB): $(LIB_OBJ) 
	ar rcs $(addprefix $(LIB_DIR)/, $@) $(addprefix $(OBJ_DIR)/, $^)

# Create obj directory for .o files.
lib_mkdir:
	mkdir -p $(OBJ_DIR)
	mkdir -p $(LIB_DIR)

# Create all requred directories and compile a static library.
lib: lib_mkdir $(ALIB)

# Call example's makefile to compile example app.
example:
	make -f ./example/config.mk

# Call lib's tests makefile to compile test executable and run tests with code coverage generation.
lib_test:
	make -f ./test/config.mk lib_test

# Call example's tests makefile to compile test executable and run tests with code coverage generation.
example_test:
	make -f ./example/test/config.mk example_test

# Call both example's tests and lib's tests.
test: example_test lib_test

# Clean Up Library, Coverage files.
lib_clean:
	rm -rf $(OBJ_DIR) $(LIB_DIR) 
	rm -rf $(LIB_SRC:.c=.gcda) $(LIB_SRC:.c=.gcno)

# Call all clean up dependencies to perform full clean.
clean: lib_clean
	make -f ./example/config.mk example_clean
	make -f ./example/test/config.mk example_test_clean
	make -f ./test/config.mk lib_test_clean

.PHONY: lib example lib_test example_test test clean
