Name:           flat-remix
Version:        20190109
Release:        1
License:        GPLv3
Summary:        Flat Remix icon theme
Url:            https://drasite.com/flat-remix
Group:          User Interface/Desktops
Source:         https://github.com/daniruiz/%{name}/archive/%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch

%description
Flat remix is a pretty simple icon theme inspired on material design.

This package contains the following icon themes:

 - Flat Remix
 - Flat Remix Dark
 - Flat Remix Light

%prep
%setup -q

%install
%make_install

%build

%post
for theme in \
    "Flat-Remix" \
    "Flat-Remix-Dark" \
    "Flat-Remix-Light"
do
    /bin/touch --no-create /usr/share/icons/${theme} &>/dev/null || :
    /usr/bin/gtk-update-icon-cache -q /usr/share/icons/${theme} || :
done


%postun
if [ $1 -eq 0 ]; then
    for theme in \
        "Flat-Remix" \
        "Flat-Remix-Dark" \
        "Flat-Remix-Light"
    do
        /bin/touch --no-create /usr/share/icons/${theme} &>/dev/null || :
        /usr/bin/gtk-update-icon-cache -q /usr/share/icons/${theme} || :
    done
fi

%files
%defattr(-,root,root)
%doc LICENSE README.md CREDITS
%{_datadir}/icons/Flat-Remix-Dark
%{_datadir}/icons/Flat-Remix-Light
%{_datadir}/icons/Flat-Remix
%ghost %{_datadir}/icons/Flat-Remix-Dark/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix-Light/icon-theme.cache
%ghost %{_datadir}/icons/Flat-Remix/icon-theme.cache

%changelog
* Mon Feb 19 2018 Daniel Ruiz de Alegría <daniruizdealegria@gmail.com> - 20180219-1
- Initial Build
