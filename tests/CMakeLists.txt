# This is a test for the bootstrap script in this repository.
# It is NOT meant to be used by consumers
cmake_minimum_required(VERSION 3.15)

project(bootstrap-tolc-cmake)

add_library(bootstrap src/Boot/bootstrap.cpp)
target_include_directories(bootstrap PUBLIC include)

get_filename_component(rootDir ${PROJECT_SOURCE_DIR} DIRECTORY)
add_subdirectory(${rootDir} bootstrap)
get_tolc()

# Creates the target bootstrap_python that can be imported with python
tolc_create_translation(
  # Target to translate from
  TARGET bootstrap
  # Language to target
  LANGUAGE python
  # Where to put the bindings
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/python-bindings)

# Lets try to use it!
find_package(Python3 REQUIRED)
add_custom_target(
  importBootstrap ALL
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMAND ${Python3_EXECUTABLE} -c \"import bootstrap\"
)
# Make sure it only tries to import it after bootstrap_python is built
add_dependencies(importBootstrap bootstrap_python)
