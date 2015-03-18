set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/open_dmlib")
set (GETTEXT_PACKAGE "open_dmlib")
set (CMAKE_C_FLAGS "-g -O3")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

configure_file (${CMAKE_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_BINARY_DIR}/src/Config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_definitions (${DEPS_CFLAGS})
link_libraries ( ${DEPS_LIBRARIES} )
link_directories ( ${DEPS_LIBRARY_DIRS} )
find_package (Vala REQUIRED)
include( UseVala )

set (VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gobject-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} dmtestlib-1.0)
set (VALA_PACKAGES ${VALA_PACKAGES} posix)
set (VALA_PACKAGES ${VALA_PACKAGES} zlib)
set (VALA_PACKAGES ${VALA_PACKAGES} magick_wand)

set (OPEN_DMLIB_SOURCES ${OPEN_DMLIB_SOURCES} open_dmlib.vala)

if(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DOS_WINDOWS")
else()
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DOS_LINUX")
endif()

set (CUSTOM_VAPIS_LIST binreloc.vapi)

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
if(NOT DEFINED CMAKE_INSTALL_LIBDIR)
  set(CMAKE_INSTALL_LIBDIR lib)
endif(NOT DEFINED CMAKE_INSTALL_LIBDIR)
set(prefix       ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX})
set(libdir       ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR})
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
