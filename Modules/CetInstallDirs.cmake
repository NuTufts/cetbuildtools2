#.rst:
# CetInstallDirs
# --------------
#
# .. code-block:: cmake
#
#   include(CetInstallDirs)
#
# Define GNU/UPS standard and CET project installation directories
#
# Cetbuildtools2 supports two different filesystem hierarchies for
# installation
#
# * Defined by the `GNU Coding Standards`_
# * Defined by the `CET/FNAL UPS Product Install Policy`_
#
# Additional installation directories for common CET project resources
# such as `FHiCL`_ and `GDML`_ configuration files are specified.
#
# .. _`GNU Coding Standards`: https://www.gnu.org/prep/standards/html_node/Directory-Variables.html
# .. _`CET/FNAL UPS Product Install Policy`: https://cdcvs.fnal.gov/redmine/projects/cet-is/wiki/Policy_guidelines_for_building_installing_and_deploying
# .. _`FHiCL`: https://cdcvs.fnal.gov/redmine/projects/fhicl
# .. _`GDML`: http://gdml.web.cern.ch/GDML
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# Inclusion of this module defines the following variables
#
# ``CMAKE_INSTALL_<dir>``
#
#   Destination for files of a given type.  This value may be passed to
#   the ``DESTINATION`` options of :cmake:command:`install` commands for the
#   corresponding file type.
#
# ``CMAKE_INSTALL_FULL_<dir>``
#
#   The absolute path generated from the corresponding ``CMAKE_INSTALL_<dir>``
#   value.  If the value is not already an absolute path, an absolute path
#   is constructed typically by prepending the value of the
#   :cmake:variable:`CMAKE_INSTALL_PREFIX` variable.
#
# where ``<dir>`` is one of the values as defined in the
# :cmake:module:`GNUInstallDirs module <cmake:module:GNUInstallDirs>`,
# plus the CET extensions
#
# ``CMAKEDIR``
#   CMake "ProjectConfig" and extension module files (defaults to ``LIBDIR/cmake/``)
#
#   This makes the assumption that projects will install binaries. If that is not
#   the case for your project, consider setting this to ``CMAKE_INSTALL_DATAROOTDIR/cmake``
#   after inclusion of this module.
#
# ``FCLDIR``
#   FHiCL configuration files (defaults to ``DATAROOTDIR/fhicl``)
# ``GDMLDIR``
#   GDML configuration files (defaults to ``DATAROOTDIR/gdml``)
#
# Install Hierarchy Policies
# ^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# By default, the GNU install policy is used. All ``CMAKE_INSTALL_<dir>``
# variables will have the defaults as defined in :cmake:module:`GNUInstallDirs <cmake:module:GNUInstallDirs>`
# and may be set on the command line on in the CMake interactive dialogs.
#
# .. todo::
#
#   Selection/Activation of UPS Install Policy
#
# Install/Build Directory Functions
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# The following functions are available to query and manipulate
# install and build output directories

#-----------------------------------------------------------------------
# Copyright 2016 Ben Morgan <Ben.Morgan@warwick.ac.uk>
# Copyright 2016 University of Warwick
#
# Distributed under the OSI-approved BSD 3-Clause License (the "License");
# see accompanying file License.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Core includes
#
include(CMakeParseArguments)

#-----------------------------------------------------------------------
# GNU Install Policy - inline for now
#
include(GNUInstallDirs)

# -- Provide additional variables for CMake/FHICL/GDML dirs
# Assumed that CMake Package Configuration files are architecture dependent
# Not *always* true, but gives a good default
# TODO: See if this could be chosen..
if(NOT CMAKE_INSTALL_CMAKEDIR)
  set(CMAKE_INSTALL_CMAKEDIR "" CACHE PATH "CMake package configuration files (LIBDIR/cmake)")
  set(CMAKE_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake")
endif()

# FHICL files are always architecture independent
# - Policy at present is to follow other man/doc style and use "fhicl/PROJECT_NAME"
#   Could equally use PROJECT_NAME/fhicl as default if better fit
if(NOT CMAKE_INSTALL_FHICLDIR)
  set(CMAKE_INSTALL_FHICLDIR "" CACHE PATH "FHICL configuration files (DATAROOTDIR/fhicl/PROJECT_NAME)")
  set(CMAKE_INSTALL_FHICLDIR "${CMAKE_INSTALL_DATAROOTDIR}/fhicl/${PROJECT_NAME}")
endif()

# GDML files are always architecture independent
# - Policy at present is to follow other man/doc style and use "gdml/PROJECT_NAME"
#   Could equally use PROJECT_NAME/gdml as default if better fit
if(NOT CMAKE_INSTALL_GDMLDIR)
  set(CMAKE_INSTALL_GDMLDIR "" CACHE PATH "GDML configuration files (DATAROOTDIR/gdml/PROJECT_NAME)")
  set(CMAKE_INSTALL_GDMLDIR "${CMAKE_INSTALL_DATAROOTDIR}/gdml/${PROJECT_NAME}")
endif()

# - As with other dirs,
#   - provide absolute path variables
#   - mark as advanced
# None of these variables are special cases like etc/var, so handling is simple
foreach(dir CMAKEDIR FHICLDIR GDMLDIR)
  mark_as_advanced(CMAKE_INSTALL_${dir})
  if(NOT IS_ABSOLUTE "${CMAKE_INSTALL_${dir}}")
    set(CMAKE_INSTALL_FULL_${dir} "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_${dir}}")
  else()
    set(CMAKE_INSTALL_FULL_${dir} "${CMAKE_INSTALL_${dir}}")
  endif()
endforeach()

#[[.rst:
.. cmake:command:: cet_set_output_directories

  .. code-block:: cmake

    cet_set_output_directories()

  :cmake:command:`Function <cmake:command:function>` that sets the
  values of the default output directories for CMake targets to
  match to the install hierarchy.

  For single mode build generators (make, ninja), the following
  hierarchy is used:

  .. code-block:: console

    +- <PROJECT_BINARY_DIR>/
       +- BuildProducts/
          +- <CMAKE_INSTALL_BINDIR>/
             +- ... "runtime" targets ...
          +- <CMAKE_INSTALL_LIBDIR>/
             +- ... "library" and "archive" targets ...

  For multimode build generators (Xcode, Visual Studio), each mode
  is separated using the hierarchy

  .. code-block:: console

    +- <PROJECT_BINARY_DIR>
       +- BuildProducts/
          +- <CONFIG>/
             +- <CMAKE_INSTALL_BINDIR>/
                +- ... "runtime" targets ...
             +- <CMAKE_INSTALL_LIBDIR>/
                +- ... "library" and "archive" targets ...
          +- ...

  where ``<CONFIG>`` is repeated for each build configuration listed in
  :cmake:variable:`CMAKE_CONFIGURATION_TYPES <cmake:variable:CMAKE_CONFIGURATION_TYPES>`, e.g. Release, Debug, RelWithDebInfo etc.
  Currently always called by inclusion of the ``CetInstallDirs``
  module.

  .. todo::

    Consider taking a base directory argument and review default call
#]]
function(cet_set_output_directories)
  set(CSODIRS_BASE_DIR "${PROJECT_BINARY_DIR}/BuildProducts")
  # - Defaults for single-mode generators
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
    "${CSODIRS_BASE_DIR}/${CMAKE_INSTALL_BINDIR}"
    PARENT_SCOPE
    )
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY
    "${CSODIRS_BASE_DIR}/${CMAKE_INSTALL_LIBDIR}"
    PARENT_SCOPE
    )
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY
    "${CSODIRS_BASE_DIR}/${CMAKE_INSTALL_LIBDIR}"
    PARENT_SCOPE
    )

  # - Multimode generator overrides
  foreach(_conftype ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${_conftype} _conftype_uppercase)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${_conftype_uppercase}
      "${CSODIRS_BASE_DIR}/${_conftype}/${CMAKE_INSTALL_BINDIR}"
      PARENT_SCOPE
      )
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${_conftype_uppercase}
      "${CSODIRS_BASE_DIR}/${_conftype}/${CMAKE_INSTALL_LIBDIR}"
      PARENT_SCOPE
      )
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${_conftype_uppercase}
      "${CSODIRS_BASE_DIR}/${_conftype}/${CMAKE_INSTALL_LIBDIR}"
      PARENT_SCOPE
      )
  endforeach()
endfunction()

# - Default call
cet_set_output_directories()
