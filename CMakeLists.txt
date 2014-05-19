### CMakeLists automatically created with AutoVala
### Do not edit

project (open_dmlib)
cmake_minimum_required (VERSION 2.6)
cmake_policy (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
option(ICON_UPDATE "Update the icon cache after installing" ON)
option(BUILD_VALADOC "Build API documentation if Valadoc is available" OFF)

set( OPEN_DMLIB_MAJOR 1 )
set( OPEN_DMLIB_MINOR 0 )
set( OPEN_DMLIB_RELEASE 0 )
set( OPEN_DMLIB_NAME open_dmlib-${OPEN_DMLIB_MAJOR}.${OPEN_DMLIB_MINOR} )
set( OPEN_DMLIB_VERSION ${OPEN_DMLIB_MAJOR}.${OPEN_DMLIB_MINOR}.${OPEN_DMLIB_RELEASE} )

set(HAVE_VALADOC OFF)
if(BUILD_VALADOC)
	find_package(Valadoc)
	if(VALADOC_FOUND)
		set(HAVE_VALADOC ON)
		include(Valadoc)
	else()
		message("Valadoc not found, will not build documentation")
	endif()
endif()

find_package(PkgConfig)

set (MODULES_TO_CHECK glib-2.0 dmtestlib-1.0 gobject-2.0 gio-2.0 gthread-2.0 MagickWand zlib)
pkg_check_modules(DEPS REQUIRED ${MODULES_TO_CHECK})

add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(doc)