Name:           time-machine
Version:        VERSION
Release:        1
Summary:        Time tracker for freelancers
License:        Proprietary
BuildArch:      x86_64
Requires:       gtk3

%description
A minimal cross-platform time tracking application for freelancers.
Track time by project with a simple start/stop timer.

%install
install -dm755 %{buildroot}/usr/lib/time_machine
cp -r %{_builddir}/bundle/* %{buildroot}/usr/lib/time_machine/

printf '#!/bin/bash\nexec /usr/lib/time_machine/time_machine "$@"\n' \
    | install -Dm755 /dev/stdin %{buildroot}/usr/bin/time_machine

install -Dm644 %{_builddir}/time_machine.desktop \
    %{buildroot}/usr/share/applications/time_machine.desktop
install -Dm644 %{_builddir}/icon.png \
    %{buildroot}/usr/share/icons/hicolor/256x256/apps/time_machine.png

%files
/usr/lib/time_machine/
/usr/bin/time_machine
/usr/share/applications/time_machine.desktop
/usr/share/icons/hicolor/256x256/apps/time_machine.png
