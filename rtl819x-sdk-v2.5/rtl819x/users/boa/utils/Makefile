ifeq ($(wildcard $(DIR_LINUX)/.config),)
include ../../../linux-2.6.30/.config
else
include $(DIR_LINUX)/.config
endif

ifeq ($(wildcard $(DIR_USERS)/.config),)
include ../../.config
else
include $(DIR_USERS)/.config
endif

ifdef CONFIG_RTL_8198_AP_ROOT
AP=1
SKUTAG=ap
else
GW=1
SKUTAG=gw
endif

#------------------------------------------------------------------------------
ifndef COMMON_CFLAGS
$(error COMMON_CFLAGS is not defined)
endif

ifndef APMIB_SHARED
$(error APMIB_SHARED is not defined)
endif

ifndef APMIB_LIB
$(error APMIB_LIB is not defined)
endif

#------------------------------------------------------------------------------
.SUFFIXES:
.SUFFIXES: .o .c
.PHONY: clean all depend

LDFLAGS =  -g
CFLAGS = -Os -pipe
DEPEND = ./.depend


#------------------------------------------------------------------------------
APMIB_DIR=../apmib

#------------------------------------------------------------------------------
# EXTRA_CFLAGS
#------------------------------------------------------------------------------
EXTRA_CFLAGS =

#------------------------------------------------------------------------------
# CFLAGS
#------------------------------------------------------------------------------
DEBUG	= -g -Wall
IFLAGS 	= -I. -I$(APMIB_DIR)
CFLAGS += $(COMMON_CFLAGS) $(EXTRA_CFLAGS)

SOURCES = flash.c comapi.c

#------------------------------------------------------------------------------
# targets
#------------------------------------------------------------------------------
all: depend flash

ifeq ($(CONFIG_RTL_COMAPI_CFGFILE),y)
flash: Makefile flash.o comapi.o $(APMIB_DIR)/$(APMIB_LIB)
	$(CC) -o $@ flash.o comapi.o $(LDFLAGS) -L$(APMIB_DIR) -lapmib
	rsdk-linux-strip $@
else
flash: Makefile flash.o $(APMIB_DIR)/$(APMIB_LIB)
	$(CC) -o $@ flash.o $(LDFLAGS) -L$(APMIB_DIR) -lapmib
	rsdk-linux-strip $@
endif

clean:
	rm -f $(DEPEND)
	rm -f *.o flash

depend: $(SOURCES)
	if [ ! -e $(DEPEND) ]; then \
		$(CPP) $(DEBUG) $(CFLAGS) $(IFLAGS) -MM $^ > $(DEPEND); \
	fi
	
-include $(DEPEND)

.c.o:
	${CC} -c -o $@ $(DEBUG) $(CFLAGS) $(IFLAGS) $<
