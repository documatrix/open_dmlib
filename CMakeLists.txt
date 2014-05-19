### CMakeLists automatically created with AutoVala
### Do not edit

project (dblib)
cmake_minimum_required (VERSION 2.6)
cmake_policy (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
option(ICON_UPDATE "Update the icon cache after installing" ON)
option(BUILD_VALADOC "Build API documentation if Valadoc is available" OFF)

set( DBLIB_MAJOR 1 )
set( DBLIB_MINOR 0 )
set( DBLIB_RELEASE 0 )
set( DBLIB_NAME dblib-${DBLIB_MAJOR}.${DBLIB_MINOR} )
set( DBLIB_VERSION ${DBLIB_MAJOR}.${DBLIB_MINOR}.${DBLIB_RELEASE} )

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

EXEC_PROGRAM(
  mysql_config
ARGS
  --cflags
OUTPUT_VARIABLE
  MYSQL_CFLAGS
)

EXEC_PROGRAM(
  mysql_config
ARGS
  --libs
OUTPUT_VARIABLE
  MYSQL_LIBS
)

EXEC_PROGRAM(
  which
ARGS
  preprocess_logger.pl
OUTPUT_VARIABLE
  PREPROCESS_LOGGER
)


set (VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gobject-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} dmtestlib-1.0)
set (VALA_PACKAGES ${VALA_PACKAGES} posix)
set (VALA_PACKAGES ${VALA_PACKAGES} zlib)
set (VALA_PACKAGES ${VALA_PACKAGES} mysql)
set (VALA_PACKAGES ${VALA_PACKAGES} open_dmlib-1.0)
set (VALA_PACKAGES ${VALA_PACKAGES} dm_logger-1.0)

set (MODULES_TO_CHECK glib-2.0 dmtestlib-1.0 gobject-2.0 gio-2.0 gthread-2.0 zlib open_dmlib-1.0 dm_logger-1.0)
pkg_check_modules(DEPS REQUIRED ${MODULES_TO_CHECK})

add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(doc)
