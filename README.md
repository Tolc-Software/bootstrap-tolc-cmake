# Bootstrap `tolc` with `CMake` #

![Ubuntu](https://github.com/Tolc-Software/bootstrap-tolc-cmake/workflows/Ubuntu/badge.svg) ![MacOS](https://github.com/Tolc-Software/bootstrap-tolc-cmake/workflows/MacOS/badge.svg)

[Signup to influence the development of `tolc`](https://srydell.github.io/tolc/signup/)

`CMake` downloader for the C++ language bindings generator `tolc`.

This `CMake` module allows you to download the beta release of `tolc` to then generate bindings from headers and `CMake` targets.

## Installation ##

Clone and use `add_subdirectory(path/to/bootstrap)` within your project.

You can also download it automatically via `CMake`:

```cmake
include(FetchContent)
FetchContent_Declare(
  tolc_bootstrap
  GIT_REPOSITORY https://github.com/Tolc-Software/bootstrap-tolc-cmake
  GIT_TAG        main
)

FetchContent_MakeAvailable(tolc_bootstrap)
```

## Usage ##

The bootstrap script only provides the function `get_tolc()` which downloads the latest release of `tolc`.

A full example:

```cmake
cmake_minimum_required(VERSION 3.15)

project(bootstrap-tolc-cmake)

# Some library to generate bindings from
add_library(bootstrap src/Boot/bootstrap.cpp)
target_include_directories(bootstrap PUBLIC include)

include(FetchContent)
FetchContent_Declare(
  tolc_bootstrap
  GIT_REPOSITORY https://github.com/Tolc-Software/bootstrap-tolc-cmake
  GIT_TAG        main
)

FetchContent_MakeAvailable(tolc_bootstrap)
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
