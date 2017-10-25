# - Build sphinx docs for cetbuildtools2
#
option(SPHINX_BUILD_HTML "Build html help with Sphinx" OFF)

if(NOT SPHINX_BUILD_HTML)
  return()
endif()

#-----------------------------------------------------------------------
# Sphinx docs
# - Using CMake's generation as example
# - NB... Need CMake's cmake.py module and other infrastructure so that
#   module files and cmake constructs can be passed.
# - Also look at intersphinx for cross-referencing to the CMake docs
find_program(SPHINX_EXECUTABLE
  NAMES sphinx-build
  DOC "Sphinx Documentation Builder (sphinx-doc.org)"
  )

if(NOT SPHINX_EXECUTABLE)
  message(FATAL_ERROR "SPHINX_EXECUTABLE (sphinx-build) was not found")
endif()

# - Set up conf.py
set(sphinx_conf_path "${CMAKE_CURRENT_SOURCE_DIR}")
configure_file(conf.py.in conf.py @ONLY)

# - Format selection/configuration
set(sphinx_output_formats "html")

# - Process each format
set(doc_format_outputs "")
set(doc_format_last "")

foreach(format ${sphinx_output_formats})
  set(doc_format_output  "doc_format_${format}")
  set(doc_format_log "build-${format}.log")

  # Copy license to root format directory
  configure_file("${PROJECT_SOURCE_DIR}/LICENSE" "${CMAKE_CURRENT_BINARY_DIR}/${format}/LICENSE" COPYONLY)

  add_custom_command(
    OUTPUT ${doc_format_output}
    COMMAND ${SPHINX_EXECUTABLE}
            -c "${CMAKE_CURRENT_BINARY_DIR}"
            -d "${CMAKE_CURRENT_BINARY_DIR}/doctrees"
            -b ${format}
            "${CMAKE_CURRENT_SOURCE_DIR}"
            "${CMAKE_CURRENT_BINARY_DIR}/${format}"
            > "${doc_format_log}"
    DEPENDS ${doc_format_last}
    COMMENT "sphinx-build ${format}: see documentation/${doc_format_log}"
    VERBATIM
    )
  set_property(SOURCE ${doc_format_output} PROPERTY SYMBOLIC 1)
  list(APPEND doc_format_outputs ${doc_format_output})
  set(doc_format_last ${doc_format_output})
endforeach()

# - Target for building all formats
add_custom_target(documentation ALL DEPENDS ${doc_format_outputs})

# - Install
install(
  DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/html"
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/documentation
  PATTERN .buildinfo EXCLUDE
  )



