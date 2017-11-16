cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)

project("bookmark-sync-subdirs")
set(SUBDIRS_PREFIX "../..")
enable_testing()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)
include_directories(BEFORE SYSTEM
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/${SUBDIRS_PREFIX}"
    "${CMAKE_CURRENT_SOURCE_DIR}/${SUBDIRS_PREFIX}/3rdparty/include"
)

add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${CPP_UTILITIES_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/reflective-rapidjson reflective-rapidjson)
list(APPEND CMAKE_MODULE_PATH ${REFLECTIVE_RAPIDJSON_SOURCE_DIR}/cmake/modules)
link_directories(${REFLECTIVE_RAPIDJSON_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/3rdparty/pistache pistache)
link_directories("${CMAKE_BINRARY_DIR}/pistache")

add_subdirectory(${SUBDIRS_PREFIX}/bookmarksync bookmarksync)
