PROJECT_ARCH = aarch64
PROJECT = libvirt
TOOLCHAIN=$(PROJECT_ARCH)-musl-cross
PACKAGE_CACHE=$(PROJECT)-$(PROJECT_ARCH)-package-cache

#if TAG is set, use it for the value of docker build . -t $TAG, otherwise use the arch,project,target name
define DOCKER_BUILD
docker build $\
--build-arg PACKAGE_CACHE=$(PACKAGE_CACHE) $\
--build-arg PROJECT_ARCH=$(PROJECT_ARCH) $\
--build-arg PROJECT=$(PROJECT) $\
--build-arg TOOLCHAIN=$(TOOLCHAIN) -f Dockerfile.$1 $\
-t $(if $(TAG),$(TAG),$(PROJECT)-$(PROJECT_ARCH)-$1) . 
endef

STAMP = touch $@

#https://stackoverflow.com/a/39124162/229631
word-dot = $(word $2,$(subst ., ,$1))

.DEFAULT_GOAL = libvirt
.PHONY: clean

#https://stackoverflow.com/a/8822668/229631
.%.stamp:
	$(call DOCKER_BUILD,$(call word-dot,$*,1))
	touch $@


gnutls: .gnutls.stamp

libvirt: gnutls glib meson rpcgen .libvirt.stamp

rpcgen: .rpcgen.stamp

package-cache: .package-cache.stamp
	@echo Cache in image $(PACKAGE_CACHE)

$(TOOLCHAIN): TAG=$(TOOLCHAIN)
$(TOOLCHAIN): .musl-cross.stamp

meson: .meson.stamp

zlib: .zlib.stamp

pcre: .pcre.stamp

libmount: .libmount.stamp

libffi: .libffi.stamp 

gettext: .gettext.stamp
 
glib: meson gettext libffi libmount pcre zlib .glib.stamp

qemu: qemu-source pixman glib ncurses .qemu.stamp  

qemu-source: .qemu-source.stamp

pixman: .pixman.stamp

ncurses: .ncurses.stamp


clean: 
	@rm -v $(wildcard .*.stamp)