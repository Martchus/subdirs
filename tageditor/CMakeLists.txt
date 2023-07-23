cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)

project("tageditor-subdirs")
set(SUBDIRS_PREFIX "../..")
enable_testing()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
set(c++utilities${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/c++utilities")
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${CPP_UTILITIES_BINARY_DIR})

option(WIDGETS_GUI "enables/disables building the Qt Widgets GUI: yes (default) or no" ON)
option(QUICK_GUI "enables/disables building the Qt Quick GUI: yes (default) or no" ON)
if(WIDGETS_GUI OR QUICK_GUI)
    add_subdirectory(${SUBDIRS_PREFIX}/qtutilities qtutilities)
    set(qtutilities${CONFIGURATION_PACKAGE_SUFFIX_QTUTILITIES}_DIR "${CMAKE_CURRENT_BINARY_DIR}/qtutilities")
    list(APPEND CMAKE_MODULE_PATH ${QT_UTILITIES_SOURCE_DIR}/cmake/modules)
    link_directories(${QT_UTILITIES_BINARY_DIR})
endif()

option(ENABLE_JSON_EXPORT "enable JSON export" OFF)
if(ENABLE_JSON_EXPORT)
    add_subdirectory(${SUBDIRS_PREFIX}/reflective-rapidjson reflective-rapidjson)
    set(reflective-rapidjson${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/reflective-rapidjson")
    list(APPEND CMAKE_MODULE_PATH ${REFLECTIVE_RAPIDJSON_SOURCE_DIR}/cmake/modules)
    link_directories(${REFLECTIVE_RAPIDJSON_BINARY_DIR})
endif()

add_subdirectory(${SUBDIRS_PREFIX}/tagparser tagparser)
set(tagparser${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/tagparser")
link_directories(${TAG_PARSER_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/tageditor tageditor)
