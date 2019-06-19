Name:           flat-remix
Version: 20190619
Release:        1
License:        GPLv3
Summary:        Flat Remix icon theme
Url:            https://drasite.com/flat-remix
Group:          User Interface/Desktops
Source:         https://github.com/daniruiz/%{name}/archive/%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch

%description
Flat remix is a pretty simple icon theme inspired on material design following a modern design using "flat" colors with high contrasts and sharp borders.

Themes:
 • Flat Remix: main theme
 • Flat Remix Dark: for dark interfaces
 • Flat Remix Light: for light interfaces

Folder variants:
 • Blue Folders
 • Green Folders
 • Red Folders
 • Yellow Folders


%prep
%setup -q

%install
%make_install

%build

%post
for theme in Flat-Remix-Blue Flat-Remix-Blue-Dark Flat-Remix-Blue-Light Flat-Remix-Green Flat-Remix-Green-Dark Flat-Remix-Green-Light Flat-Remix-Red Flat-Remix-Red-Dark Flat-Remix-Red-Light Flat-Remix-Yellow Flat-Remix-Yellow-Dark Flat-Remix-Yellow-Light
do
    /bin/touch --no-create /usr/share/icons/${theme} &>/dev/null || :
    /usr/bin/gtk-update-icon-cache -q /usr/share/icons/${theme} || :
done


%postun
if [ $1 -eq 0 ]; then
    for theme in Flat-Remix-Blue Flat-Remix-Blue-Dark Flat-Remix-Blue-Light Flat-Remix-Green Flat-Remix-Green-Dark Flat-Remix-Green-Light Flat-Remix-Red Flat-Remix-Red-Dark Flat-Remix-Red-Light Flat-Remix-Yellow Flat-Remix-Yellow-Dark Flat-Remix-Yellow-Light
    do
        /bin/touch --no-create /usr/share/icons/${theme} &>/dev/null || :
        /usr/bin/gtk-update-icon-cache -q /usr/share/icons/${theme} || :
    done
fi

%files
%defattr(-,root,root)
%doc LICENSE README.md AUTHORS
%{_datadir}/icons/Flat-Remix-Blue
%{_datadir}/icons/Flat-Remix-Blue-Dark
%{_datadir}/icons/Flat-Remix-Blue-Light
%{_datadir}/icons/Flat-Remix-Green
%{_datadir}/icons/Flat-Remix-Green-Dark
%{_datadir}/icons/Flat-Remix-Green-Light
%{_datadir}/icons/Flat-Remix-Red
%{_datadir}/icons/Flat-Remix-Red-Dark
%{_datadir}/icons/Flat-Remix-Red-Light
%{_datadir}/icons/Flat-Remix-Yellow
%{_datadir}/icons/Flat-Remix-Yellow-Dark
%{_datadir}/icons/Flat-Remix-Yellow-Light
%ghost %{_datadir}/icons/Flat-Remix-Blue/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Blue-Dark/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Blue-Light/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Green/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Green-Dark/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Green-Light/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Red/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Red-Dark/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Red-Light/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Yellow/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Yellow-Dark/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Yellow-Light/icon-theme.cache
