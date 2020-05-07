set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/open_dmlib")
set (GETTEXT_PACKAGE "open_dmlib")
set (CMAKE_C_FLAGS "-g -O3")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

configure_file (${CMAKE_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_BINARY_DIR}/src/Config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
find_package (Vala REQUIRED)
include( UseVala )

set (VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gobject-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} dmtestlib-1.0)
set (VALA_PACKAGES ${VALA_PACKAGES} posix)
set (VALA_PACKAGES ${VALA_PACKAGES} zlib)
set (VALA_PACKAGES ${VALA_PACKAGES} magick_wand)
if ( NOT ${CMAKE_SYSTEM_NAME} STREQUAL Windows )
  if ( GUDEV )
    set ( VALA_PACKAGES ${VALA_PACKAGES} gudev-1.0 )
  endif( )
endif( )

set (OPEN_DMLIB_SOURCES ${OPEN_DMLIB_SOURCES} open_dmlib.vala)


if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DOS_WINDOWS")
  set (CMAKE_VALA_OPTS ${CMAKE_VALA_OPTS} -D OS_WINDOWS)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL Darwin)
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DOS_MACOSX")
  set (CMAKE_VALA_OPTS ${CMAKE_VALA_OPTS} -D OS_MACOSX)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL Emscripten)
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DOS_EMSCRIPTEN")
  set (CMAKE_VALA_OPTS ${CMAKE_VALA_OPTS} -D OS_EMSCRIPTEN)
else()
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DOS_LINUX")
  set (CMAKE_VALA_OPTS ${CMAKE_VALA_OPTS} -D OS_LINUX)
endif()

if ( GUDEV )
  set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DLIB_GUDEV" )
  set ( CMAKE_VALA_OPTS ${CMAKE_VALA_OPTS} -D LIB_GUDEV )
endif( )

set (CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} binreloc.vapi)
set (CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} open_dmlib_io.vapi)
set (CUSTOM_VAPIS_LIST ${CUSTOM_VAPIS_LIST} windows.vapi)


vala_precompile(OPEN_DMLIB_VALA_C
  ${OPEN_DMLIB_SOURCES}
PACKAGES
  ${VALA_PACKAGES}
GENERATE_VAPI
  ${OPEN_DMLIB_NAME}
CUSTOM_VAPIS
  ${CUSTOM_VAPIS_LIST}
GENERATE_HEADER
  open_dmlib
OPTIONS
  --thread -g --vapidir=. --vapidir=${CMAKE_INSTALL_PREFIX}/share/vala/vapi
  ${VAPIDIRS_ARGS} ${CMAKE_VALA_OPTS}
)

add_library(
  ${OPEN_DMLIB_NAME} SHARED
  ${OPEN_DMLIB_VALA_C} binreloc.c
)

# CREATE PKGCONFIG FILES
if(NOT DEFINED CMAKE_INSTALL_BINDIR)
  set(CMAKE_INSTALL_BINDIR bin)
endif(NOT DEFINED CMAKE_INSTALL_BINDIR)
if(NOT DEFINED CMAKE_INSTALL_LIBDIR)
  set(CMAKE_INSTALL_LIBDIR lib)
endif(NOT DEFINED CMAKE_INSTALL_LIBDIR)
set(prefix       ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX})
if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
  set(libdir       ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR})
else()
  set(libdir       ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR})
endif()
set(includedir  ${CMAKE_INSTALL_PREFIX}/include)
set(LIBS         "")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libopen_dmlib.pc.in
  ${CMAKE_CURRENT_BINARY_DIR}/${OPEN_DMLIB_NAME}.pc @ONLY)

if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
# Install shared object
install(
TARGETS
  ${OPEN_DMLIB_NAME}
DESTINATION
bin/
)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL Emscripten)
# Install shared object
install(
TARGETS
  ${OPEN_DMLIB_NAME}
LIBRARY DESTINATION
lib/
ARCHIVE DESTINATION
lib/
)
else()
# Install shared object
install(
TARGETS
  ${OPEN_DMLIB_NAME}
LIBRARY DESTINATION
lib/
)
endif( )

# Install header files
install(
FILES
  ${CMAKE_CURRENT_BINARY_DIR}/open_dmlib.h
DESTINATION
  include/${OPEN_DMLIB_NAME}/
)

# Install vapi files
install(
FILES
  ${CMAKE_CURRENT_BINARY_DIR}/${OPEN_DMLIB_NAME}.vapi
  ${CMAKE_CURRENT_BINARY_DIR}/magick_wand.vapi
  ${CMAKE_CURRENT_BINARY_DIR}/windows.vapi
  ${CMAKE_CURRENT_BINARY_DIR}/open_dmlib_io.vapi
DESTINATION
  ${CMAKE_INSTALL_PREFIX}/share/vala/vapi/
)

# Install pkg-config file...
install( FILES
  ${CMAKE_CURRENT_BINARY_DIR}/${OPEN_DMLIB_NAME}.pc
DESTINATION
  ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)

if(HAVE_VALADOC)
  valadoc(open_dmlib
    ${CMAKE_BINARY_DIR}/valadoc/open_dmlib
    ${APP_SOURCES}
  PACKAGES
    ${VALA_PACKAGES}
  CUSTOM_VAPIS
    ${CUSTOM_VAPIS_LIST}
  )
  install(DIRECTORY
    ${CMAKE_BINARY_DIR}/valadoc
  DESTINATION
    share/doc/open_dmlib
  )
endif()
