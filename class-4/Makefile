SHELL := /bin/bash

######################################################################
### EXECUTABLES

CC    = gcc
FLAGS = -O3 -Wall
RM    = rm -rf

######################################################################
### TARGET FILES

MAIN = matrix-add

######################################################################
### CLEAN-UP FILES

FILES_CLEAN = $(MAIN) *~

######################################################################
### COMMANDS -- ! DO NOT CHANGE BELOW !

all: $(MAIN)

$(MAIN): $(MAIN).c
	$(CC) $(FLAGS) $< -o $@

clean:
	$(RM) $(FILES_CLEAN)
