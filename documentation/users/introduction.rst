Introduction to cetbuildtools2
------------------------------

Cetbuildtools2 is a collection of CMake Modules that a CMake-based
project can use to apply FNAL/CET common build settings to the build
of C, C++ and Fortran libraries and executables. Using ``cetbuildtools``
in your project is a simple case of locating it using CMake's
``find_package`` command and then loading the modules you need:

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.3)
  project(foo VERSION 1.2.3)

  find_package(cetbuildtools2 REQUIRED)
  set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
  # Or list(APPEND CMAKE_MODULE_PATH "${cetbuildtools2_MODULE_PATH}")
  # if your project uses additional module paths
  include(CetInstallDirs)
  include(CetCMakeSettings)
  include(CetCompilerSettings)

If ``cetbuildtools2`` is not installed in the default locations known
to CMake, then you can help CMake to locate it by using:

1. (Recommended) Use the ``CMAKE_PREFIX_PATH`` variable as a command line argument to CMake (or set as a Path-style
   variable in the environment) to point CMake to the installation prefix under which ``cetbuildtools2`` is installed. For
   example, if it was installed under ``/another/install/dir``, then the example project could be configured as::

   $ cmake -DCMAKE_PREFIX_PATH=/another/install/dir <otherargs>

   See also the `documentation for the find_package command`_

2. (Not Recommended) Paths hardcoded or obtained from non-standard environment variable passed as arguments to ``find_package``

.. _`documentation for the find_package command`: https://cmake.org/cmake/help/v3.0/command/find_package.html

The following sections describe the functionality available from the
supplied modules.

