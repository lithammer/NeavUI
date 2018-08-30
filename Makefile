VERSION ?= $(shell git tag --list --contains HEAD)

ifeq ($(strip $(VERSION)),)
VERSION := $(shell git rev-parse --short HEAD)
endif

NEAVUI_ZIP = NeavUI_v$(VERSION).zip
NMAINBAR_ZIP = nMainbar_v$(VERSION).zip
OUF_NEAV_ZIP = oUF_Neav_v$(VERSION).zip

PROJECTS = $(NEAVUI_ZIP) $(NMAINBAR_ZIP) $(OUF_NEAV_ZIP)

all: build

build: $(PROJECTS)

clean:
	$(RM) *.zip

$(NMAINBAR_ZIP):
	(cd Interface/AddOns; zip -r "$(CURDIR)/$@" !Beautycase nMainbar -x '*.git*' '.DS_Store')
	zip $@ LICENSE

$(NEAVUI_ZIP):
	zip -r $@ Fonts Interface LICENSE -x '*.git*' '.DS_Store'

$(OUF_NEAV_ZIP):
	(cd Interface/AddOns; zip -r "$(CURDIR)/$@" !Beautycase oUF oUF_Neav oUF_NeavRaid -x '*.git*' '.DS_Store')
	zip $@ LICENSE
