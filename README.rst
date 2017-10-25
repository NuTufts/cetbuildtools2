cetbuildtools2: CMake Modules for FNAL CET Projects
***************************************************

.. image:: https://travis-ci.org/drbenmorgan/cetbuildtools2.svg?branch=develop
    :target: https://travis-ci.org/drbenmorgan/cetbuildtools2

A rewrite of the `FNAL cetbuildtools`_ `CMake`_ modules to

1. Decouple the functionality from the `FNAL UPS`_ configuration management system

2. Modernize CMake usage

The intent is to keep gross functionality (compiling/linking flags and policy)
the same, whilst lower level interfaces such as target creation will be factored
to keep as close as possible to CMake interfaces.

.. _`FNAL cetbuildtools`: https://cdcvs.fnal.gov/redmine/projects/cetbuildtools
.. _`CMake`: https://www.cmake.org
.. _`FNAL UPS`: https://cdcvs.fnal.gov/redmine/projects/ups

License
-------
``cetbuildtools2`` is distributed under the OSI-approved BSD 3-clause License.
See `LICENSE`_ for details.

.. _`LICENSE`: LICENSE

Installing ``cetbuildtools2``
-----------------------------
Prerequisites:

* `CMake`_ 3.3 or higher
* *Optional:* `Sphinx`_ for building HTML and man documentation

Create build directory outside the ``cetbuildtools2`` source directory (i.e.
the directory holding this README file:

.. code-block:: console

  $ ls
  cetbuildtools2.git
  $ mkdir cetbuildtools2.build
  $ cd cetbuildtools2.build

Run cmake in the build directory to configure the project, supplying a directory
under which the programs and files should be installed plus the path to the
``cetbuildtools2`` source directory:

.. code-block:: console

  $ cmake -DCMAKE_INSTALL_PREFIX=/some/install/dir ../cetbuildtools2.git

To enable the build of the documentation, also pass `-DSPHINX_BUILD_HTML=ON`
to `cmake` in the above command line. To build and install ``cetbuildtools2``
to the location chosen above, run cmake again, passing  the ``--build`` and ``--target``
arguments as follows:

.. code-block:: console

  $ cmake --build . --target install

Before installing, unit tests may be run by building the ``test`` target:

.. code-block:: console

  $ cmake --build . --target test

Using ``cetbuildtools2``
------------------------
Like any other package, ``cetbuildtools2`` may be located by CMake-based projects using CMake's ``find_package`` command:

.. code-block:: cmake

  cmake_minimum_required(VERSION 3.0)
  project(foo VERSION 1.2.3)

  find_package(cetbuildtools2 REQUIRED)
  set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
  # Or list(APPEND CMAKE_MODULE_PATH "${cetbuildtools2_MODULE_PATH}")
  # if your project uses additional module paths
  include(CetInstallDirs)
  include(CetCMakeSettings)
  include(CetCompilerSettings)

If ``cetbuildtools2`` is not installed in the default locations known to CMake, then you can help CMake to locate it by
using:

1. (Recommended) Use the ``CMAKE_PREFIX_PATH`` variable as a command line argument to CMake (or set as a Path-style
   variable in the environment) to point CMake to the installation prefix under which ``cetbuildtools2`` is installed. For
   example, if it was installed under ``/another/install/dir``, then the example project could be configured as::

   $ cmake -DCMAKE_PREFIX_PATH=/another/install/dir <otherargs>

   See also the `documentation for the find_package command`_

2. (Not Recommended) Paths hardcoded or obtained from non-standard environment variable passed as arguments to ``find_package``

.. _`documentation for the find_package command`: https://cmake.org/cmake/help/v3.0/command/find_package.html


Why reStructured Text for Documentation?
----------------------------------------

CMake modules can be documented using RST, and processed via CMake itself and/or
`Sphinx`_ to generate command-line, manual and webpage docs. Might as well
get this in place from the start!

.. _`Sphinx`: http://www.sphinx-doc.org/en/stable/

