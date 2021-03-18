project(BootstrapTolc VERSION 0.1)

set(tolc_bootstrap_dir
  ${CMAKE_CURRENT_LIST_DIR}
  CACHE
    PATH
  "The path to the bootstrap tolc directory")

# Internal function
function(_tolc_fetch_release content_name)
  set(supportedPlatforms "Linux;Darwin;Windows")
  if(${CMAKE_HOST_SYSTEM_NAME} IN_LIST supportedPlatforms)
    # All fetchcontent stuff uses lowercase names
    string(TOLOWER "${content_name}" content)

    include(${tolc_bootstrap_dir}/cmake/GithubHelpers.cmake)
	set(github_token_argument "")
	if(DEFINED ENV{GITHUB_AUTH_TOKEN})
      set(github_token_argument "GITHUB_TOKEN;$ENV{GITHUB_AUTH_TOKEN}")
    endif()
    _tolc_fetch_asset_from_github(
      FETCH_VARIABLE
        ${content}
      USER
        Tolc-Software
      REPOSITORY
        tolc-beta
      TAG
        beta-release
      ASSET_NAME
        tolc-${CMAKE_HOST_SYSTEM_NAME}-beta.tar.gz
      CODE_DIR
        ${tolc_bootstrap_dir}/tools
	  ${github_token_argument})
    set(${content}_SOURCE_DIR ${${content}_SOURCE_DIR} PARENT_SCOPE)
  else()
    string(REPLACE ";" ", " formatedPlatforms ${supportedPlatforms})
    message(FATAL_ERROR "${CMAKE_HOST_SYSTEM_NAME} is currently not supported by tolc. The currently supported platforms are [${formatedPlatforms}].")
  endif()
endfunction()

macro(get_tolc)
  _tolc_fetch_release(tolc_entry)

  set(tolc_ROOT ${tolc_entry_SOURCE_DIR})
  find_package(
    tolc
    CONFIG
    PATHS
    ${tolc_ROOT}
    REQUIRED
    NO_DEFAULT_PATH)
endmacro()
