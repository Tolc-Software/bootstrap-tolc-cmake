include_guard()

# Internal function
function(_fetch_tolc contentName)
  set(supportedPlatforms "Linux;Darwin")
  if(${CMAKE_HOST_SYSTEM_NAME} IN_LIST supportedPlatforms)
    include(FetchContent)

    # All fetchcontent stuff uses lowercase names
    string(TOLOWER "${contentName}" content)

    FetchContent_Declare(
      ${content}
      URL https://github.com/Tolc-Software/tolc-beta/releases/download/beta-release/tolc-${CMAKE_HOST_SYSTEM_NAME}-beta.tar.gz
    )

    FetchContent_Populate(${content})
    message(STATUS "source: ${${content}_SOURCE_DIR}")
    message(STATUS "binary: ${${content}_BINARY_DIR}")
    set(${content}_SOURCE_DIR ${${content}_SOURCE_DIR} PARENT_SCOPE)
  else()
    string(REPLACE ";" ", " formatedPlatforms ${supportedPlatforms})
    message(FATAL_ERROR "${CMAKE_HOST_SYSTEM_NAME} is currently not supported by tolc. The currently supported platforms are [${formatedPlatforms}].")
  endif()
endfunction()

macro(get_tolc)
  _fetch_tolc(tolc_entry)

  set(tolc_ROOT ${tolc_entry_SOURCE_DIR})
  find_package(
    tolc
    CONFIG
    PATHS
    ${tolc_ROOT}
    REQUIRED
    NO_DEFAULT_PATH)
endmacro()
