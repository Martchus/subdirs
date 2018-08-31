cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)

project("passwordmanager-subdirs")
set(SUBDIRS_PREFIX "../..")
enable_testing()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${CPP_UTILITIES_BINARY_DIR})

option(WIDGETS_GUI "enables/disables building the Qt Widgets GUI: yes (default) or no" ON)
option(QUICK_GUI "enables/disables building the Qt Quick GUI: yes (default) or no" ON)
if(WIDGETS_GUI OR QUICK_GUI)
    add_subdirectory(${SUBDIRS_PREFIX}/qtutilities qtutilities)
    list(APPEND CMAKE_MODULE_PATH ${QT_UTILITIES_SOURCE_DIR}/cmake/modules)
    link_directories(${QT_UTILITIES_BINARY_DIR})
endif()
if(QUICK_GUI)
    set(ECM_PATH OFF CACHE PATH "specifies the (relative) path to the extra-cmake-modules sources for building it together with passwordmanager")
    if(NOT ECM_PATH)
        message(STATUS "Using system extra-cmake-modules (ECM_PATH not set)")
    else()
        # FIXME: building ecm in the same project doesn't seem to work since it has references to the installed location
        add_subdirectory("${ECM_PATH}" ecm)
        #file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/bundled-ecm")
        #file(WRITE "${CMAKE_BINARY_DIR}/bundled-ecm/ECMConfig.cmake" "set(ECM_MODULE_DIR ${ECM_PATH}/modules)")
        set(ECM_DIR "${CMAKE_BINARY_DIR}/bundled-ecm")
        list(APPEND CMAKE_MODULE_PATH
            "${ECM_PATH}/modules"
            "${ECM_PATH}/kde-modules"
            "${ECM_PATH}/find-modules"
        )
    endif()

    set(KIRIGAMI_PATH OFF CACHE PATH "specifies the (relative) path to the Kirigami 2 sources for building it together with passwordmanager")
    if(NOT KIRIGAMI_PATH)
        message(STATUS "Using system Kirigami (KIRIGAMI_PATH not set)")
    else()
        add_subdirectory("${KIRIGAMI_PATH}" kirigami)
        list(APPEND CMAKE_MODULE_PATH "${KIRIGAMI_PATH}")
    endif()
endif()

add_subdirectory(${SUBDIRS_PREFIX}/passwordfile passwordfile)
link_directories(${PASSWORD_FILE_BINARY_DIR})

add_subdirectory(${SUBDIRS_PREFIX}/passwordmanager passwordmanager)
