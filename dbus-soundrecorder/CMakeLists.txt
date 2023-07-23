cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)

project("dbus-soundrecorder-subdirs")
set(SUBDIRS_PREFIX "../..")
enable_testing()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)

add_subdirectory(${SUBDIRS_PREFIX}/qtutilities qtutilities)
list(APPEND CMAKE_MODULE_PATH ${QT_UTILITIES_SOURCE_DIR}/cmake/modules)

add_subdirectory(${SUBDIRS_PREFIX}/dbus-soundrecorder dbus-soundrecorder)
