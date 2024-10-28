libname = progress_bar
FC = gfortran

#version
major = 1
minor = 0
release = 0
version = $(major).$(minor).$(release)

#Source files
SOURCE = progress_bar.f90

#directores
srcdir = src
buildir = build
objdir = obj

#object files
OBJECTS = $(patsubst %.f90, $(objdir)/%.o, $(SOURCE))

#libraries directories
FORTRANLIB = $(HOME)/Fortran
LIB = $(FORTRANLIB)/lib
INC = $(FORTRANLIB)/include


.PHONY : install all test readme cleanlib

all : install $(LIB)/lib$(libname).so 

$(LIB)/lib$(libname).so.$(version): $(OBJECTS) 
	$(FC) -shared -o $@ $^	

$(objdir)/%.o: $(srcdir)/%.f90 $(objdir) 
	$(FC) -O3 -fpic -c -J $(INC) $< -o $@

$(LIB)/lib$(libname).so.$(major) : $(LIB)/lib$(libname).so.$(version)
	ln -s $< $@

$(LIB)/lib$(libname).so : $(LIB)/lib$(libname).so.$(major)
	ln -s $< $@

$(objdir):
	mkdir -p $@

install:
	./install.sh

test: $(buildir)
	@$(FC) -I$(INC) tests/test.f90 -L$(LIB) -l$(libname) -o $(buildir)/test
	@LD_LIBRARY_PATH=$(LIB) $(buildir)/test

$(buildir):
	mkdir -p $@

readme:
	pandoc -f gfm README.md -o $(buildir)/README.pdf
	@echo "README.pdf in build directory."

cleanlib:
	rm -r $(LIB)/lib$(libname).* $(INC)/lib$(libname).*
