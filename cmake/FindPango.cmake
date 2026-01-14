find_package(PkgConfig)
pkg_check_modules(PC_PANGO pango QUIET)

find_path(PANGO_INCLUDE_DIR
    NAMES
        pango/pango.h
    HINTS
        ${PC_PANGO_INCLUDEDIR}
        ${PC_PANGO_INCLUDE_DIRS}
)

set(PANGO_RESOLVED_LIBRARIES "")
foreach(lib ${PC_PANGO_LIBRARIES})
    find_library(LIB_PATH_${lib}
        NAMES ${lib}.dll lib${lib}.dll ${lib} lib${lib}
        HINTS ${PC_PANGO_LIBDIR} ${PC_PANGO_LIBRARY_DIRS} ${CMAKE_PREFIX_PATH}
        PATH_SUFFIXES lib bin
    )
    if(LIB_PATH_${lib})
        list(APPEND PANGO_RESOLVED_LIBRARIES ${LIB_PATH_${lib}})
    else()
        list(APPEND PANGO_RESOLVED_LIBRARIES ${lib})
    endif()
endforeach()

# Also find GLib, GObject, GModule explicitly to be sure
foreach(mod glib-2.0 gobject-2.0 gmodule-2.0)
    pkg_check_modules(PC_${mod} QUIET ${mod})
    foreach(lib ${PC_${mod}_LIBRARIES})
        find_library(LIB_PATH_${lib}
            NAMES ${lib}.dll lib${lib}.dll ${lib} lib${lib}
            HINTS ${PC_${mod}_LIBDIR} ${PC_${mod}_LIBRARY_DIRS} ${CMAKE_PREFIX_PATH}
            PATH_SUFFIXES lib bin
        )
        if(LIB_PATH_${lib})
            list(APPEND PANGO_RESOLVED_LIBRARIES ${LIB_PATH_${lib}})
        endif()
    endforeach()
endforeach()

list(REMOVE_DUPLICATES PANGO_RESOLVED_LIBRARIES)
set(PANGO_LIBRARIES ${PANGO_RESOLVED_LIBRARIES})
set(PANGO_INCLUDE_DIRS ${PANGO_INCLUDE_DIR} ${PC_PANGO_INCLUDE_DIRS} ${PC_GLIB_INCLUDE_DIRS} ${PC_GOBJECT_INCLUDE_DIRS} ${PC_GMODULE_INCLUDE_DIRS})
list(REMOVE_DUPLICATES PANGO_INCLUDE_DIRS)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Pango DEFAULT_MSG
    PANGO_INCLUDE_DIR PANGO_LIBRARIES
)

mark_as_advanced(PANGO_INCLUDE_DIR PANGO_LIBRARIES)


