# Bootstrap `tolc` with `CMake` #

![Ubuntu](https://github.com/Tolc-Software/bootstrap-tolc-cmake/workflows/Ubuntu/badge.svg) ![MacOS](https://github.com/Tolc-Software/bootstrap-tolc-cmake/workflows/MacOS/badge.svg)

`CMake` downloader for the C++ language bindings generator `tolc`.

This `CMake` module allows you to download the beta release of `tolc` to then generate bindings from headers and `CMake` targets.

## Installation ##

The only file that is needed is the `tolc.cmake` module located in the root of this repository.

You could also download it automatically via `CMake`:

```cmake
# Download automatically, you can also just copy the tolc.cmake file
if(NOT EXISTS "${CMAKE_BINARY_DIR}/tolc.cmake")
  message(STATUS "Downloading tolc.cmake from https://github.com/Tolc-Software/bootstrap-tolc-cmake")
  file(
    DOWNLOAD
      "https://github.com/Tolc-Software/bootstrap-tolc-cmake/raw/main/tolc.cmake"
      "${CMAKE_BINARY_DIR}/tolc.cmake"
    TLS_VERIFY
      ON
  )
endif()

include(${CMAKE_BINARY_DIR}/tolc.cmake)
```

## Usage ##

`tolc.cmake` only provides the function `get_tolc()` which downloads and finds the latest release of `tolc`.

A full example:

```cmake
cmake_minimum_required(VERSION 3.11)

project(bootstrap-tolc-cmake)

# Some library to generate bindings from
add_library(bootstrap src/Boot/bootstrap.cpp)
target_include_directories(bootstrap PUBLIC include)

# Assumes tolc.cmake is next to this file or in CMAKE_MODULES_PATH
include(tolc.cmake)
# Download and uses find_package to locate tolc
get_tolc()

# This function comes from the tolc package itself
# Creates the target bootstrap_python that can be imported and used from python
tolc_create_translation(
  # Target to translate from
  TARGET bootstrap
  # Language to target
  LANGUAGE python
  # Where to put the bindings
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/python-bindings
)
```
