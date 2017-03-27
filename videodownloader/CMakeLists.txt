cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)

project("videodownloader-subdirs")
set(SUBDIRS_PREFIX "../..")
enable_testing()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)
include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/${SUBDIRS_PREFIX}")

add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${CPP_UTILITIES_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/qtutilities qtutilities)
list(APPEND CMAKE_MODULE_PATH ${QT_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${QT_UTILITIES_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/videodownloader videodownloader)
