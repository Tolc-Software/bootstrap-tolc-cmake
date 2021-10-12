include_guard()

# Downloads the latest release from the beta release repo
# Args:
#   content_name - variable to populate in FetchContent
function(_tolc_fetch_release content_name)
  set(supportedPlatforms "Linux;Darwin;Windows")
  if(${CMAKE_HOST_SYSTEM_NAME} IN_LIST supportedPlatforms)
    # All fetchcontent stuff uses lowercase names
    string(TOLOWER ${content_name} lcName)

    message(STATUS "Fetching asset from Tolc-Software/tolc-beta")
    include(FetchContent)
    FetchContent_Declare(
      ${lcName}
      URL https://github.com/Tolc-Software/tolc-beta/releases/download/beta-release/tolc-${CMAKE_HOST_SYSTEM_NAME}-beta.tar.gz
      HTTP_HEADER "Accept: application/octet-stream")
    FetchContent_Populate(${lcName})
  
    if(NOT ${lcName}_POPULATED)
      FetchContent_Populate(${lcName})
    endif()

    # Export variables to caller
    set(${lcName}_SOURCE_DIR ${${lcName}_SOURCE_DIR} PARENT_SCOPE)
  else()
    string(REPLACE ";" ", " formatedPlatforms ${supportedPlatforms})
    message(FATAL_ERROR "${CMAKE_HOST_SYSTEM_NAME} is currently not supported by tolc. The currently supported platforms are [${formatedPlatforms}].")
  endif()
endfunction()
