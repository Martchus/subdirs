cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)

project("passwordmanager-subdirs")
set(SUBDIRS_PREFIX "../..")

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)
include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/${SUBDIRS_PREFIX}")

# use custom build of cppunit
#export CXXFLAGS="-std=c++11 -Wno-deprecated-declarations -D_GLIBCXX_USE_CXX11_ABI=0"
#../../src/cppunit/autogen.sh
#../../src/cppunit/configure --disable-static --prefix=/usr
#make
#make check
#make DESTDIR=/run/media/devel/build/miscinstall/ install
link_directories("/run/media/devel/build/miscinstall/usr/lib/")

add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)

add_subdirectory(${SUBDIRS_PREFIX}/qtutilities qtutilities)
list(APPEND CMAKE_MODULE_PATH ${QT_UTILITIES_SOURCE_DIR}/cmake/modules)

add_subdirectory(${SUBDIRS_PREFIX}/passwordfile passwordfile)
add_subdirectory(${SUBDIRS_PREFIX}/passwordmanager tageditor)
