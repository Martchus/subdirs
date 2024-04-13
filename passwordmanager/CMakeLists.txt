cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)

project("passwordmanager-subdirs")
set(SUBDIRS_PREFIX "../..")
enable_testing()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
set(c++utilities${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/c++utilities")
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${CPP_UTILITIES_BINARY_DIR})

if (QT_PACKAGE_PREFIX STREQUAL "Qt6")
    # set variables to build KF against Qt 6 as well
    set(BUILD_WITH_QT6 ON)
    set(EXCLUDE_DEPRECATED_BEFORE_AND_AT CURRENT)
    set(QT_MAJOR_VERSION "6")
endif ()

set(BUILD_QUICK_GUI_BY_DEFAULT ON)
if (WIN32 OR APPLE)
    set(BUILD_QUICK_GUI_BY_DEFAULT OFF)
endif ()
option(QUICK_GUI "enables/disables building the Qt Quick GUI using Kirigami" "${BUILD_QUICK_GUI_BY_DEFAULT}")
option(WIDGETS_GUI "enables/disables building the Qt Widgets GUI" ON)
if(WIDGETS_GUI OR QUICK_GUI)
    add_subdirectory(${SUBDIRS_PREFIX}/qtutilities qtutilities)
    set(qtutilities${CONFIGURATION_PACKAGE_SUFFIX_QTUTILITIES}_DIR "${CMAKE_CURRENT_BINARY_DIR}/qtutilities")
    list(APPEND CMAKE_MODULE_PATH ${QT_UTILITIES_SOURCE_DIR}/cmake/modules)
    link_directories(${QT_UTILITIES_BINARY_DIR})
endif()
if(QUICK_GUI)
    # note: Building ECM as part of the project doesn't work. Simply build ECM sparately like
    # "cmake -G Ninja -DBUILD_WITH_QT6=ON -DCMAKE_INSTALL_PREFIX=/home/martchus/build/qtcreator2/build-passwordmanager-Desktop-Debug/install /home/martchus/more_projects/kde/extra-cmake-modules"
    # and set that install dir as ECM_DIR=/home/martchus/build/qtcreator2/build-passwordmanager-Desktop-Debug/install/share/ECM/cmake.

    set(KIRIGAMI_PATH OFF CACHE PATH "specifies the (relative) path to the Kirigami 2 sources for building it together with passwordmanager")
    if(NOT KIRIGAMI_PATH)
        message(STATUS "Using system Kirigami (KIRIGAMI_PATH not set)")
    else()
        add_subdirectory("${KIRIGAMI_PATH}" kirigami)
        list(APPEND CMAKE_MODULE_PATH "${KIRIGAMI_PATH}")
    endif()
endif()

add_subdirectory(${SUBDIRS_PREFIX}/passwordfile passwordfile)
set(passwordfile${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/passwordfile")
link_directories(${PASSWORD_FILE_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/passwordmanager passwordmanager)
