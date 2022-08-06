PROJECT = lfs
PROJECT_ARCH = $(shell uname -m)
PACKAGE_CACHE = $(PROJECT)-$(PROJECT_ARCH)-package-cache

#if TAG is set, use it for the value of docker build . -t $TAG
define DOCKER_BUILD
docker build $\
--build-arg PROJECT_ARCH=$(PROJECT_ARCH) $\
--build-arg PACKAGE_CACHE=$(PACKAGE_CACHE) $\
--build-arg PROJECT=$(PROJECT) -f Dockerfile.$1 $\
-t $(if $(TAG),$(TAG),$(PROJECT)-$(PROJECT_ARCH)-$1) . 
endef

#TODO: is there a better way to grab logs when a Dockerfile fails to build?
define GRAB_LOG
	docker run --rm --mount type=bind,source=$(shell pwd)/output/,target=/output $(PROJECT)-$(PROJECT_ARCH)-$1 cp -Rv /lfs/logs/ /output
endef

define RUN
	docker run -it $(PROJECT)-$(PROJECT_ARCH)-$1
endef

%.log:
	$(call GRAB_LOG,$*,1)

run-%:
	$(call RUN,$*,1)

#https://stackoverflow.com/a/39124162/229631
word-dot = $(word $2,$(subst ., ,$1))

.DEFAULT_GOAL = all
.PHONY: clean todo save %.log run-%

all: binutils gcc libstdcpp glibc m4 ncurses bash get-logs

#https://stackoverflow.com/a/8822668/229631
.%.stamp:
	$(call DOCKER_BUILD,$(call word-dot,$*,1))
	touch $@

package-cache: sources .package-cache.stamp

debian-builder: package-cache .debian-builder.stamp

binutils: debian-builder .binutils.stamp

gcc: binutils .gcc.stamp

glibc: gcc .glibc.stamp

libstdcpp: glibc binutils .libstdcpp.stamp

m4: .m4.stamp

ncurses: libstdcpp .ncurses.stamp

bash: .bash.stamp

#TODO: exclude package-cache from clean?
clean:
	@rm -v $(wildcard .*.stamp)

todo:
	sed -i $$(grep -n "# todo" README.md | cut -d ':' -f1),\$$d README.md
	echo "# todo" >> README.md
	#https://stackoverflow.com/questions/15136366/how-to-use-non-capturing-groups-in-grep
	grep --line-number --only-matching --perl-regexp --recursive '(?<=^#TODO:).+' scripts/ Dockerfile.* Makefile | sort | sed 's/.*/\* &\n/'  >> README.md

sources: .sources.stamp

#TODO: accept an argument to save a single image instead of all of them
export:
	./scripts/99-export.sh

#TODO: look up how make rule parameters work, create a generic target that passes a $TARGET to the Dockerfile so that m4, ncurses and bash can be rolled into it

