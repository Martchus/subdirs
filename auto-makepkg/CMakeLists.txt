cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)

project("auto-makepkg-subdirs")
set(SUBDIRS_PREFIX "../..")
enable_testing()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

get_filename_component(RAPIDJSON_INCLUDE_DIRS "${SUBDIRS_PREFIX}/3rdparty/rapidjson/include" ABSOLUTE)
if (EXISTS "${RAPIDJSON_INCLUDE_DIRS}")
    set(RapidJSON_FOUND YES)
    message(STATUS "Found custom RapidJSON under: ${RAPIDJSON_INCLUDE_DIRS}")
endif ()

option(USE_LIBARCHIVE "uses libarchive; if disabled archiving utilities will not be available" ON)
add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
set(c++utilities${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/c++utilities")
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${CPP_UTILITIES_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/passwordfile passwordfile)
set(passwordfile${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/passwordfile")
link_directories(${PASSWORD_FILE_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/reflective-rapidjson reflective-rapidjson)
set(reflective_rapidjson${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/reflective-rapidjson/lib")
list(APPEND CMAKE_MODULE_PATH ${REFLECTIVE_RAPIDJSON_SOURCE_DIR}/cmake/modules)
link_directories(${REFLECTIVE_RAPIDJSON_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/auto-makepkg auto-makepkg)
