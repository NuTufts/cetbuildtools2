#.rst:
# CetUPS
# ------
#
# Configure and develop project using settings obtained from CET's
# UPS configuration management tool. These settings override any set
# by the user and cannot be modified. The enforced settings include:
#
# - Installation locations
# - Build type
#
# In particular, multiconfig tools like Xcode cannot be used in
# UPS builds as UPS only understands single mode builds.
#
# UPS Project Files
# ^^^^^^^^^^^^^^^^^
#
# Projects capable of being built in UPS-mode must instrument their
# source directory with a `ups` directory holding a `product_deps`
# file and a `setup_for_development` script.
#
# UPS Setup for Development
# ^^^^^^^^^^^^^^^^^^^^^^^^^
#
# The following sequence of operations/scripts is performed (NB,
# may not be complete as yet)
#
# - It's assumed that the `ups` product is already setup
#
#   - Usually indicated by presence of `ups` program in ``PATH``
#     or setting of ``UPS_DIR`` environment variable
#
# - User creates build directory, and ``source`` s the ``ups/setup_for_development``
#   script for the project to be built, supplying the build type and
#   any further qualifiers
#
# - This script runs the ``set_dev_products`` program that reads the
#   ``ups/product_deps`` file and writes two files to the build directory:
#
#   - A shell script, "product_name-ups_version" to be sourced by ``setup_for_development`` that
#     setups needed products and sets further UPS/cetbuildtools specific
#     environment variables.
#   - A text file, "cetpkg_variable_support", that holds the UPS/cetbuildtools
#     variables as KEY VALUE pairs.
#
# - User runs CMake using the invocation ``cmake -DCMAKE_INSTALL_PREFIX=<path> -DCMAKE_BUILD_TYPE=$CETPKG_TYPE $CETPKG_SOURCE``
#   where the ``CETPKG_`` variables are those set in the environment by
#   the script.
#
#
# UPS Tools
# ^^^^^^^^^
#
# Several shell/perl scripts are installed by cetbuildtools2 that
# run setup, query the UPS system and generate install-time files
#


#-----------------------------------------------------------------------
# Copyright 2016 Ben Morgan <Ben.Morgan@warwick.ac.uk>
# Copyright 2016 University of Warwick
#
# Distributed under the OSI-approved BSD 3-Clause License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#-----------------------------------------------------------------------


