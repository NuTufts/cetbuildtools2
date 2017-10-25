Documenting CMake Modules and other Constructs
----------------------------------------------

cetbuildtools2 provides a vendored copy of CMake's Sphinx extension to parse 
and generate documentation for CMake modules. `Intersphinx`_ is used to 
cross-reference to the upstream CMake documentation where required. 
It's therefore recommended to document modules and their functionality using the 
domain and style guides outlined in the :cmake:manual:`CMake Developer Guide <cmake:manual:cmake-developer(7)>`.

Documenting a Module
^^^^^^^^^^^^^^^^^^^^
To integrate a module ``<module-name>`` into the cetbuildtools2 documentation, create a
new ``.rst`` file in ``documentation/users`` named ``<module-name>.rst``. The contents of this 
file only needs to contain the single line:

.. code-block:: rest

  .. cmake-module:: ../../Modules/<module-name>.cmake

To add this document in the build, simply add it in the ``documentation/index.rst``
under the "Using cetbuildtools2" toctree, keeping the entries in alphabetical order.
For example, adding a new module ``bar``:

.. code-block:: rest

  .. toctree::
     :maxdepth: 2
     :hidden: 
     :caption: Using cetbuildtools2

     /users/introduction
     /users/alice
     /users/bar
     /users/bob

Simply rebuild and the new module should appear in the generated documentation
. Open ``<build-dir>/documentation/html/index.html`` in a browser and check
that the document appears and is formatted correctly.

.. _`Intersphinx`: http://www.sphinx-doc.org/en/stable/ext/intersphinx.html

Keeping Section Levels Consistent
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To ensure that the TOC panels remain consistent when browsing through the documentation,
use the following characters for marking sections (underlines etc):

``-``
  Title of any document one level below the ``documentation/`` directory
``^``
  Sections of any document one level below the ``documentation/`` directory

