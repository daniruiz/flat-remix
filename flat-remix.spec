Name:           flat-remix
Version: 20211106
Release:        1
License:        GPLv3
Summary:        Flat Remix icon theme
Url:            https://drasite.com/flat-remix
Group:          User Interface/Desktops
Source:         https://github.com/daniruiz/%{name}/archive/%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch
BuildRequires:  make

%description
Flat Remix is an icon theme inspired by material design. It is mostly flat using a colorful palette with some shadows, highlights, and gradients for some depth.

%prep
%setup -q

%install
%make_install

%build

%post
for theme in %{_datadir}/icons/Flat-Remix*
do
    touch --no-create %{_datadir}/icons/${theme} &> /dev/null || :
    gtk-update-icon-cache --force %{_datadir}/icons/${theme} &> /dev/null || :
done


%postun
if [ $1 -eq 0 ]; then
    for theme in %{_datadir}/icons/Flat-Remix*
    do
        touch --no-create %{_datadir}/icons/${theme} &> /dev/null || :
        gtk-update-icon-cache --force %{_datadir}/icons/${theme} &> /dev/null || :
    done
fi

%files
%license LICENSE
%doc README.md AUTHORS
%{_datadir}/Flat-Remix-Black-Dark
%{_datadir}/Flat-Remix-Black-Light
%{_datadir}/Flat-Remix-Blue-Dark
%{_datadir}/Flat-Remix-Blue-Light
%{_datadir}/Flat-Remix-Brown-Dark
%{_datadir}/Flat-Remix-Brown-Light
%{_datadir}/Flat-Remix-Cyan-Dark
%{_datadir}/Flat-Remix-Cyan-Light
%{_datadir}/Flat-Remix-Green-Dark
%{_datadir}/Flat-Remix-Green-Light
%{_datadir}/Flat-Remix-Grey-Dark
%{_datadir}/Flat-Remix-Grey-Light
%{_datadir}/Flat-Remix-Magenta-Dark
%{_datadir}/Flat-Remix-Magenta-Light
%{_datadir}/Flat-Remix-Orange-Dark
%{_datadir}/Flat-Remix-Orange-Light
%{_datadir}/Flat-Remix-Red-Dark
%{_datadir}/Flat-Remix-Red-Light
%{_datadir}/Flat-Remix-Teal-Dark
%{_datadir}/Flat-Remix-Teal-Light
%{_datadir}/Flat-Remix-Violet-Dark
%{_datadir}/Flat-Remix-Violet-Light
%{_datadir}/Flat-Remix-Yellow-Dark
%{_datadir}/Flat-Remix-Yellow-Light
%ghost %{_datadir}/icons/Flat-Remix-*/icon-theme.cache
