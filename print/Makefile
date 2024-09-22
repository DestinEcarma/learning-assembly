# Source files
SOURCES = main.s

# Compiler and flags
AS = as
CC = gcc
CFLAGS = -nostdlib -static

# Directory
TARGET_DIR = target
BIN_DIR = $(TARGET_DIR)/bin
OBJ_DIR = $(TARGET_DIR)/obj

# Object files
OBJECTS = $(patsubst %.s, $(OBJ_DIR)/%.o, $(SOURCES))

# Target executable
TARGET = $(BIN_DIR)/main

# Default rule to run the program
default: run
all: $(TARGET)

# Rule to link the object files to create the executable
$(TARGET): $(OBJECTS) | $(BIN_DIR)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS)

# Rule to compile the .c files into .o files
$(OBJ_DIR)/%.o: %.s $(SOURCES) | $(OBJ_DIR)
	$(AS) $< -o $@

# Rule to create the target directories if they don't exist
$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

# Rule to clean up the compiled files
clean:
	rm -rf $(TARGET_DIR)

# Rule to run the program
run: $(TARGET)
	./$(TARGET)
