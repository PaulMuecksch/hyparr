# location of the PicoSAT header and library; override on the command line,
# e.g.  make PICOSAT_INCDIR=$(HOME)/src/picosat-965 \
#            PICOSAT_LIB="$(HOME)/src/picosat-965/libpicosat.a"
# PICOSAT_INCDIR = /usr/include/picosat
# PICOSAT_LIB    = -lpicosat

# GAP     = gap
# GAPARCH = $(shell echo 'Print(GAPInfo.Architecture);' | $(GAP) -q -A -b)
# BINDIR  = bin/$(GAPARCH)

# CFLAGS  = -O2 -Wall

# all: $(BINDIR)/picoenum

# $(BINDIR)/picoenum: src/picoenum.c
# 	mkdir -p $(BINDIR)
# 	$(CC) $(CFLAGS) -I$(PICOSAT_INCDIR) -o $@ $< $(PICOSAT_LIB)

doc:
	gap -q makedoc.g

clean:
	rm -rf bin
	rm -f *.html *.pdf *.aux *.log

.PHONY: all doc clean