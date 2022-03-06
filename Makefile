PROJECT = lfs
PROJECT_ARCH = $(shell uname -m)
#if TAG is set, use it for the value of docker build . -t $TAG
define DOCKER_BUILD
docker build $\
--build-arg PROJECT_ARCH=$(PROJECT_ARCH) $\
--build-arg PROJECT=$(PROJECT) -f Dockerfile.$1 $\
-t $(if $(TAG),$(TAG),$(PROJECT)-$(PROJECT_ARCH)-$1) . 
endef

STAMP = touch $@

#https://stackoverflow.com/a/39124162/229631
word-dot = $(word $2,$(subst ., ,$1))

.DEFAULT_GOAL = lfs
.PHONY: clean

#https://stackoverflow.com/a/8822668/229631
.%.stamp:
	$(call DOCKER_BUILD,$(call word-dot,$*,1))
	touch $@


debian-builder: .debian-builder.stamp

binutils: debian-builder .binutils.stamp

get-logs: binutils .get-logs.stamp
	docker run --rm --mount type=bind,source=$(shell pwd)/output/,target=/output $(PROJECT)-$(PROJECT_ARCH)-$@ cp -Rv /lfs/logs/ /output


clean: 
	@rm -v $(wildcard .*.stamp)