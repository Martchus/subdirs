cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)

project("syncthingtray-subdirs")
set(SUBDIRS_PREFIX "../..")
enable_testing()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

# disable certain features to optimize size of Android app a little bit
if (ANDROID)
    option(USE_BOOST_PROCESS "enables use of Boost.Process instead of QProcess" OFF)
    option(USE_ICONV "enables use of iconv (not used anyway)" OFF)
    option(USE_NATIVE_FILE_BUFFER "enables use of native file buffer (not used anyway)" OFF)
    option(USE_STANDARD_FILESYSTEM "enables use of standard filesystem in c++utilities (not used anyway)" OFF)
endif ()

message(STATUS "Adding c++utilities subdir")
add_subdirectory(${SUBDIRS_PREFIX}/c++utilities c++utilities)
set(c++utilities${CONFIGURATION_PACKAGE_SUFFIX}_DIR "${CMAKE_CURRENT_BINARY_DIR}/c++utilities")
list(APPEND CMAKE_MODULE_PATH ${CPP_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${CPP_UTILITIES_BINARY_DIR})

message(STATUS "Adding qtutilities subdir")
add_subdirectory(${SUBDIRS_PREFIX}/qtutilities qtutilities)
set(qtutilities${CONFIGURATION_PACKAGE_SUFFIX_QTUTILITIES}_DIR "${CMAKE_CURRENT_BINARY_DIR}/qtutilities")
list(APPEND CMAKE_MODULE_PATH ${QT_UTILITIES_SOURCE_DIR}/cmake/modules)
link_directories(${QT_UTILITIES_BINARY_DIR})

message(STATUS "Adding syncthingtray subdir")
set(BUNDLED_QT_FORK_AWESOME_PATH "../qtforkawesome" CACHE PATH "specifies the (relative) path to the qtforkawesome sources for building it together with ${META_PROJECT_NAME}")
add_subdirectory(${SUBDIRS_PREFIX}/syncthingtray syncthingtray)
