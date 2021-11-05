Name:           flat-remix
Version: 20211105
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
for theme in /usr/share/icons/Flat-Remix*
do
    gtk-update-icon-cache --force /usr/share/icons/${theme} || :
done


%postun
if [ $1 -eq 0 ]; then
    for theme in /usr/share/icons/Flat-Remix*
    do
        gtk-update-icon-cache --force /usr/share/icons/${theme} || :
    done
fi

%files
%license LICENSE
%doc README.md AUTHORS
%dir %{_datadir}/icons/Flat-Remix-*/
%{_datadir}/icons/Flat-Remix-*/
%ghost %{_datadir}/icons/Flat-Remix-*/icon-theme.cache
