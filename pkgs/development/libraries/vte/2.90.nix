{ stdenv, fetchurl, intltool, pkgconfig, gnome3, glib, gtk3, ncurses, gobject-introspection }:

stdenv.mkDerivation rec {
  versionMajor = "0.36";
  versionMinor = "3";
  moduleName   = "vte";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "54e5b07be3c0f7b158302f54ee79d4de1cb002f4259b6642b79b1e0e314a959c";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gobject-introspection intltool glib gtk3 ncurses ];

  configureFlags = [ "--enable-introspection" ];

  enableParallelBuilding = true;

  postInstall = ''
    substituteInPlace $out/lib/libvte2_90.la --replace "-lncurses" "-L${ncurses.out}/lib -lncurses"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gnome.org/;
    description = "A library implementing a terminal emulator widget for GTK+";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK+, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
    '';
    license = licenses.lgpl2;
    maintainers = with maintainers; [ astsmtl antono lethalman ];
    platforms = platforms.linux;
  };
}
