# - Try to find FONTCONFIG
# Once done this will define
#
#  FONTCONFIG_ROOT_DIR - Set this variable to the root installation of FONTCONFIG
#  FONTCONFIG_FOUND - system has FONTCONFIG
#  FONTCONFIG_INCLUDE_DIRS - the FONTCONFIG include directory
#  FONTCONFIG_LIBRARIES - Link these to use FONTCONFIG
#
#  Copyright (c) 2008 Joshua L. Blocher <verbalshadow at gmail dot com>
#  Copyright (c) 2012 Dmitry Baryshnikov <polimax at mail dot ru>
#  Copyright (c) 2013 Michael Pavlyshko <pavlushko at tut dot by>
#
# Distributed under the OSI-approved BSD License
#

find_package(PkgConfig)
pkg_check_modules(PC_FONTCONFIG fontconfig QUIET)

FIND_PATH(FONTCONFIG_INCLUDE_DIR
    NAMES
        "fontconfig/fontconfig.h"
    HINTS
        ${PC_FONTCONFIG_INCLUDEDIR}
        ${PC_FONTCONFIG_INCLUDE_DIRS}
    PATH_SUFFIXES
        include
)

set(FONTCONFIG_RESOLVED_LIBRARIES "")
foreach(lib ${PC_FONTCONFIG_LIBRARIES})
    find_library(LIB_PATH_FC_${lib}
        NAMES ${lib}.dll lib${lib}.dll ${lib} lib${lib}
        HINTS ${PC_FONTCONFIG_LIBDIR} ${PC_FONTCONFIG_LIBRARY_DIRS} ${CMAKE_PREFIX_PATH}
        PATH_SUFFIXES lib bin
    )
    if(LIB_PATH_FC_${lib})
        list(APPEND FONTCONFIG_RESOLVED_LIBRARIES ${LIB_PATH_FC_${lib}})
    else()
        list(APPEND FONTCONFIG_RESOLVED_LIBRARIES ${lib})
    endif()
endforeach()

set(FONTCONFIG_LIBRARIES ${FONTCONFIG_RESOLVED_LIBRARIES})
set(FONTCONFIG_INCLUDE_DIRS ${FONTCONFIG_INCLUDE_DIR} ${PC_FONTCONFIG_INCLUDE_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Fontconfig DEFAULT_MSG
    FONTCONFIG_INCLUDE_DIR FONTCONFIG_LIBRARIES
)

mark_as_advanced(FONTCONFIG_INCLUDE_DIR FONTCONFIG_LIBRARIES)

return()


SET(_FONTCONFIG_ROOT_HINTS
    $ENV{FONTCONFIG}
    ${CMAKE_FIND_ROOT_PATH}
    ${FONTCONFIG_ROOT_DIR}
) 

SET(_FONTCONFIG_ROOT_PATHS
    $ENV{FONTCONFIG}/src
    /usr
    /usr/local
)

SET(_FONTCONFIG_ROOT_HINTS_AND_PATHS
    HINTS ${_FONTCONFIG_ROOT_HINTS}
    PATHS ${_FONTCONFIG_ROOT_PATHS}
)

FIND_PATH(FONTCONFIG_INCLUDE_DIR
    NAMES
        "fontconfig/fontconfig.h"
    HINTS
        ${_FONTCONFIG_INCLUDEDIR}
        ${_FONTCONFIG_ROOT_HINTS_AND_PATHS}
    PATH_SUFFIXES
        include
)  


FIND_LIBRARY(FONTCONFIG_LIBRARY
    NAMES
        fontconfig
    HINTS
        ${_FONTCONFIG_LIBDIR}
        ${_FONTCONFIG_ROOT_HINTS_AND_PATHS}
    PATH_SUFFIXES
        "lib"
        "local/lib"
)

SET(FONTCONFIG_LIBRARIES
    ${FONTCONFIG_LIBRARY}
)

SET(FONTCONFIG_INCLUDE_DIRS
    ${FONTCONFIG_INCLUDE_DIR}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Fontconfig
    REQUIRED_VARS FONTCONFIG_LIBRARIES FONTCONFIG_INCLUDE_DIRS
    FAIL_MESSAGE "Could NOT find FONTCONFIG, try to set the path to FONTCONFIG root folder in the system variable FONTCONFIG"
)

MARK_AS_ADVANCED(FONTCONFIG_INCLUDE_DIR FONTCONFIG_INCLUDE_DIRS FONTCONFIG_LIBRARY FONTCONFIG_LIBRARIES)
