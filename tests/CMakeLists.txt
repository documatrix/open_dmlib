set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/open_dmlib")
set (GETTEXT_PACKAGE "open_dmlib")
set (CMAKE_C_FLAGS "")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

configure_file (${CMAKE_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_BINARY_DIR}/src/Config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_definitions (${DEPS_CFLAGS})
include_directories( ${CMAKE_SOURCE_DIR}/src )
link_libraries ( ${DEPS_LIBRARIES} )
link_libraries ( ${OPEN_DMLIB_NAME} )
link_directories ( ${DEPS_LIBRARY_DIRS} )
find_package (Vala REQUIRED)
include( UseVala )

set (VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gobject-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} zlib)
set (VALA_PACKAGES ${VALA_PACKAGES} dmtestlib-1.0)
set (VALA_PACKAGES ${VALA_PACKAGES} posix)
set (VALA_PACKAGES ${VALA_PACKAGES} magick_wand)

set (TEST_OPEN_DMLIB_SOURCES ${TEST_OPEN_DMLIB_SOURCES} test_open_dmlib.vala)

vala_precompile(TEST_OPEN_DMLIB_VALA_C
  ${TEST_OPEN_DMLIB_SOURCES}
PACKAGES
  ${VALA_PACKAGES} ${OPEN_DMLIB_NAME}
OPTIONS
--thread -g --vapidir=${CMAKE_INSTALL_PREFIX}/share/vala/vapi --vapidir=${CMAKE_SOURCE_DIR}/src
CUSTOM_VAPIS
  ${CUSTOM_VAPIS_LIST}
)

add_executable(
  test_open_dmlib
  ${TEST_OPEN_DMLIB_VALA_C}
)

install(TARGETS
  test_open_dmlib
RUNTIME DESTINATION
  bin/
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
