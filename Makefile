VERSION = 0.7
PN = odroid-auto-bridge

PREFIX ?= /usr
INITDIR_SYSTEMD = /usr/lib/systemd/system
BINDIR = $(PREFIX)/bin

RM = rm
SED = sed
INSTALL = install -p
INSTALL_PROGRAM = $(INSTALL) -m755
INSTALL_DATA = $(INSTALL) -m644
INSTALL_DIR = $(INSTALL) -d
Q = @

common/$(PN): common/$(PN).in
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)$(SED) 's/@VERSION@/'$(VERSION)'/' common/$(PN).in > common/$(PN)

install-bin: common/$(PN)
	$(Q)echo -e '\033[1;32mInstalling main script...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(BINDIR)"
	$(INSTALL_PROGRAM) common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"

install-systemd:
	$(Q)echo -e '\033[1;32mInstalling systemd files...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(INITDIR_SYSTEMD)"
	$(INSTALL_DATA) init/$(PN).service "$(DESTDIR)$(INITDIR_SYSTEMD)/$(PN).service"

install: install-bin install-systemd

uninstall-bin:
	$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"

uninstall-systemd:
	$(RM) "$(DESTDIR)$(INITDIR_SYSTEMD)/$(PN).service"

uninstall: uninstall-bin uninstall-systemd

clean:
	$(RM) -f common/$(PN)

.PHONY: install-bin install-systemd install uninstall-bin uninstall-systemd uninstall clean
