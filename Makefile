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

define GRAB_LOG
	docker run --rm --mount type=bind,source=$(shell pwd)/output/,target=/output $(PROJECT)-$(PROJECT_ARCH)-$1 cp -Rv /lfs/logs/ /output
endef

%.log:
	$(call GRAB_LOG,$*,1)
#docker run --rm --mount type=bind,source=$(shell pwd)/output/,target=/output $(PROJECT)-$(PROJECT_ARCH)-$1 cp -Rv /lfs/logs/ /output

#https://stackoverflow.com/a/39124162/229631
word-dot = $(word $2,$(subst ., ,$1))

.DEFAULT_GOAL = all
.PHONY: clean todo save %.log

all: binutils gcc glibc

#https://stackoverflow.com/a/8822668/229631
.%.stamp:
	$(call DOCKER_BUILD,$(call word-dot,$*,1))
	touch $@

# %.log:
# 	docker run --rm --mount type=bind,source=$(shell pwd)/output/,target=/output $(PROJECT)-$(PROJECT_ARCH)-$@ cp -Rv /lfs/logs/ /output

package-cache: .package-cache.stamp

debian-builder: package-cache .debian-builder.stamp

binutils: debian-builder .binutils.stamp

gcc: binutils .gcc.stamp

libstdcpp: .libstdcpp.stamp

glibc: gcc .glibc.stamp

m4: .m4.stamp

ncurses: .ncurses.stamp

bash: .bash.stamp

get-logs: gcc .get-logs.stamp
	
#TODO: exclude package-cache from clean?
clean:
	@rm -v $(wildcard .*.stamp)

todo:
	echo >> README.md
	echo >> README.md
	echo "# todo" >> README.md
	#https://stackoverflow.com/questions/15136366/how-to-use-non-capturing-groups-in-grep
	grep --line-number --only-matching --perl-regexp --recursive '(?<=^#TODO:).+' scripts/ Dockerfile.* Makefile .buildkite/pipeline.yml | sed 's/.*/\* &\n/'  >> README.md

sources: .sources.stamp

#TODO: accept an argument to save a single image instead of all of them
export:
	./scripts/99-export.sh
