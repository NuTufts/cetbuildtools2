#.rst:
# CetMake
# -------
#
# .. code-block:: cmake
#
#   include(CetMake)
#
# Legacy Cetbuildtools/UPS module, retained temporarily for provision of
# the ``cet_script`` function used under the hood by CetTest.
#
# Use of scripts (e.g. Shell, Python, Perl) for testing of the package or
# by its clients should prefer explicit use under the following guidelines
#
# - If the script is not generated (e.g. via ``configure_file``), then it
#   should have at least user execute permissions. Tests may run the script
#   by passing the full path, e.g. ``${PROJECT_SOURCE_DIR}/scripts/myscript.sh``.
#   If the script is required by runtime clients, use the ``install(PROGRAMS ...)``
#   form of the CMake command to install it in the appropriate location with
#   needed execute permissions.
#
# - If the script is generated, either via ``configure_file`` or otherwise,
#   then the preceeding guide can be followed post-generation. In this case, the only
#   change is to refer to the script in tests and install commands via its
#   configured path, e.g. ``${PROJECT_BINARY_DIR}/scripts/myscript.sh``.
#

# OLD DOCS
########################################################################
# cet_make
#
# Identify the files in the current source directory and deal with them
# appropriately.
#
# Users may opt to just include cet_make() in their CMakeLists.txt
#
# This implementation is intended to be called NO MORE THAN ONCE per
# subdirectory.
#
# NOTE: cet_make_exec is no longer part of cet_make or art_make and must
# be called explicitly.
#
# cet_make( [LIBRARY_NAME <library name>]
#           [LIBRARIES <library link list>]
#           [SUBDIRS <source subdirectory>] (e.g., detail)
#           [USE_PRODUCT_NAME]
#           [EXCLUDE <ignore these files>] )
#
#   If USE_PRODUCT_NAME is specified, the product name will be prepended
#   to the calculated library name
#   USE_PRODUCT_NAME and LIBRARY_NAME are mutually exclusive
#
#   NOTE: if your code includes art plugins, you MUST use art_make
#   instead of cet_make: cet_make will ignore all known plugin code.
#
# cet_make_library( LIBRARY_NAME <library name>
#                   SOURCE <source code list>
#                   [LIBRARIES <library list>]
#                   [WITH_STATIC_LIBRARY]
#                   [NO_INSTALL] )
#
#   Make the named library.
#
# cet_make_exec( <executable name>
#                [SOURCE <source code list>]
#                [LIBRARIES <library link list>]
#                [USE_BOOST_UNIT]
#                [NO_INSTALL] )
#
#   Build a regular executable.
#
# cet_script( <script-names> ...
#             [DEPENDENCIES <deps>]
#             [NO_INSTALL]
#             [GENERATED]
#             [REMOVE_EXTENSIONS] )
#
#   Copy the named scripts to ${${product}_bin_dir} (usually bin/).
#
#   If the GENERATED option is used, the script will be copied from
#   ${CMAKE_CURRENT_BINARY_DIR} (after being made by a CONFIGURE
#   command, for example); otherwise it will be copied from
#   ${CMAKE_CURRENT_SOURCE_DIR}.
#
#   If REMOVE_EXTENSIONS is specified, extensions will be removed from script names
#   when they are installed.
#
#   NOTE: If you wish to use one of these scripts in a CUSTOM_COMMAND,
#   list its name in the DEPENDS clause of the CUSTOM_COMMAND to ensure
#   it gets re-run if the script chagees.
#
# cet_lib_alias(LIB_TARGET <alias>+)
#
#   Create a courtesy link to the library specified by LIB_TARGET for
#   each specified <alias>, for e.g. backward compatibility
#   reasons. LIB_TARGET must be a target defined (ultimately) by
#   add_library.
#
#   e.g. cet_lib_alias(nutools_SimulationBase SimulationBase) would
#   create a new link (e.g.) libSimulationBase.so to the generated
#   library libnutools_SimulationBase.so (replace .so with .dylib for OS
#   X systems).
#
########################################################################
include(CMakeParseArguments)

# Need to depend on (currently) installdirs to get output path for script...
include(CetInstallDirs)

#.rst:
# .. cmake:command:: cet_script
#
#   .. code-block:: cmake
#
#     cet_script(<script-names> ...
#                [DEPENDENCIES <deps>]
#                [GENERATED]
#                [REMOVE_EXTENSIONS])
#
#   Copy the named scripts to ``CMAKE_RUNTIME_OUTPUT_DIRECTORY`` for the build.
#
#   If the ``GENERATED`` option is used, the script will be copied from
#   ``CMAKE_CURRENT_BINARY_DIR`` (after being made by a ``configure_file``
#   command, for example); otherwise it will be copied from
#   ``CMAKE_CURRENT_SOURCE_DIR``.
#
#   If REMOVE_EXTENSIONS is specified, extensions will be removed from script names
#   when they are installed.
#
#   NOTE: If you wish to use one of these scripts in a CUSTOM_COMMAND,
#   list its name in the DEPENDS clause of the CUSTOM_COMMAND to ensure
#   it gets re-run if the script chagees.

macro(cet_script)
  cmake_parse_arguments(CS
    "GENERATED;NO_INSTALL;REMOVE_EXTENSIONS"
    ""
    "DEPENDENCIES"
    ${ARGN})

  if(CS_GENERATED)
    set(CS_SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR})
  else()
    set(CS_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  foreach(target_name ${CS_UNPARSED_ARGUMENTS})
    if(CS_REMOVE_EXTENSIONS)
      get_filename_component(target ${target_name} NAME_WE)
    else()
      set(target ${target_name})
    endif()

    cet_copy(${CS_SOURCE_DIR}/${target_name}
      PROGRAMS
      NAME ${target}
      NAME_AS_TARGET
      # NB: Following assumes not build mode dependent script!
      DESTINATION "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
      )

    # Install in product if desired.
    if(NOT CS_NO_INSTALL)
      message(WARNING "Installing files through cet_script is no longer supported")
    endif()
  endforeach()
endmacro()


# The following functions are stubbed out, and use is now an error:
# ``cet_make``, ``cet_make_library``, ``cet_lib_alias``. The use of
# the standard CMake commands ``add_executable``, ``add_library``,
# together with the usage requirement commands ``target_XXX`` should
# be preferred for building binaries. Installation should be explicit
# and through the builtin ``install`` command.
#
macro(_cet_check_lib_directory)
  message(FATAL_ERROR "_cet_check_lib_directory is no longer supported")
endmacro()

macro(_cet_check_bin_directory)
  message(FATAL_ERROR "_cet_check_bin_directory is no longer supported")
endmacro()

macro(cet_make_exec cet_exec_name )
  message(FATAL_ERROR "cet_make_exec is no longer supported")
endmacro()

macro(cet_make)
  message(FATAL_ERROR "cet_make is no longer supported")
endmacro()

macro(cet_make_library)
  message(FATAL_ERROR "cet_make_library is no longer supported")
endmacro()

function(cet_lib_alias LIB_TARGET)
  message(FATAL_ERROR "cet_lib_alias is no longer supported")
endfunction()
