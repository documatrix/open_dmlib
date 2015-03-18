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

if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
set(PKG_CONFIG_EXECUTABLE i686-w64-mingw32-pkg-config)
message( ${PKG_CONFIG_EXECUTABLE} )
endif()

set (MODULES_TO_CHECK glib-2.0 dmtestlib-1.0 gobject-2.0 gio-2.0 gthread-2.0 MagickWand zlib)
pkg_check_modules(DEPS REQUIRED ${MODULES_TO_CHECK})

message( "definitions: ${DEPS_CFLAGS}" )
message( "libs: ${DEPS_LIBRARIES}" )
message( "libdirs: ${DEPS_LIBRARY_DIRS}" )
foreach( PKGLIB ${DEPS_LIBRARIES} )
  message( "Search for ${PKGLIB}..." )
  find_library( _LIBS ${PKGLIB} PATHS ${DEPS_LIBRARY_DIRS})
  set( LIBS ${LIBS} ${_LIBS} )
endforeach( PKGLIB )
message( "LIBS: ${LIBS}" )

add_definitions (${DEPS_CFLAGS})
link_directories ( ${DEPS_LIBRARY_DIRS} )
link_libraries ( ${LIBS} )

set( VAPIDIRS_ARGS "" )
if( NOT ${VAPIDIRS} STREQUAL "" )
  string( REPLACE ":" ";" VAPIDIRS_LIST ${VAPIDIRS} )
  foreach ( VAPIDIR ${VAPIDIRS_LIST} )
    set( VAPIDIRS_ARGS ${VAPIDIRS_ARGS} "--vapidir=${VAPIDIR}" )
  endforeach ( VAPIDIR )
endif()

add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(doc)
