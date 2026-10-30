#!/bin/bash
set -eo pipefail

# Use the Boost and ROOT Math headers from the environment, not the
# copies bundled in the tarball.
INC=$(root-config --incdir)
rm -rf src/boost
ln -sf "${PREFIX}/include/boost" src/boost
rm -rf src/ROOT/*/Math src/ROOT/*/TMath.h
ln -sf "${INC}/Math" src/ROOT/mathcore
ln -sf "${INC}/Math" src/ROOT/smatrix
ln -sf "${INC}/TMath.h" src/ROOT/mathcore/TMath.h
rm -rf src/ROOT/genvector/Math
ln -sf "${INC}/Math" src/ROOT/genvector/Math
echo "" > src/ROOT/src/GenVector_Throw.cc

CXXFLAGS="${CXXFLAGS} $(root-config --cflags)" \
LDFLAGS="${LDFLAGS} $(root-config --libs)" \
./configure --prefix="${PREFIX}" --disable-java --disable-static \
    --with-clhep="${PREFIX}" --with-boost="${PREFIX}"
make -j"${CPU_COUNT}" CXX="${CXX}"
make install
rm -f "${PREFIX}/bin/memorytests" "${PREFIX}/bin/propagatortests"
