set -e

zbs-get update
cat tgz2build/tgz2deps | xargs -I{} zbs-get install {}
ls /opt/syslog-ng/lib/

export PKG_CONFIG_PATH="/opt/syslog-ng/lib/pkgconfig:$PKG_CONFIG_PATH"
export LIBRARY_PATH="$LIBRARY_PATH:/opt/syslog-ng/lib"
export CFLAGS="-O2 -isystem /opt/syslog-ng/include -Wl,-z,origin,-rpath,\$$ORIGIN/../lib $(pkg-config --cflags openssl)"
export LDFLAGS="$(pkg-config --libs-only-L openssl)"

DIR=$(pwd)
cd src
autoreconf -i .
./configure --prefix=/opt/syslog-ng/  
make all
make DESTDIR=${DIR}/artifacts/=install/ install
