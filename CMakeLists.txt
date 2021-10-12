cmake_minimum_required(VERSION 3.15)

project(BootstrapTolc VERSION 0.2)

set(tolc_bootstrap_dir
  ${CMAKE_CURRENT_LIST_DIR}
  CACHE
    PATH
  "The path to the bootstrap tolc directory")

macro(get_tolc)
  include(${tolc_bootstrap_dir}/cmake/GithubHelpers.cmake)
  _tolc_fetch_release(tolc_entry)

  set(tolc_ROOT ${tolc_entry_SOURCE_DIR})
  find_package(
    tolc
    CONFIG
    PATHS
    ${tolc_ROOT}
    REQUIRED
    NO_DEFAULT_PATH)
  message(STATUS "Signup to influence the development of tolc: https://srydell.github.io/tolc/signup/")
endmacro()
