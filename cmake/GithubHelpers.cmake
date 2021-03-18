include_guard()

# Download an asset from github and set the source directory to ${FETCH_VARIABLE}_SOURCE_DIR
# This allows for asset id based fetch, i.e. whenever the source is updated, it will be refetched
# Args:
#   FETCH_VARIABLE - variable to populate
#   USER - Github user account
#   REPOSITORY - Github repository name
#   TAG - Release tag, e.g. v1.0
#   ASSET_NAME - Asset to download from the tagged release, e.g. dist.tar.gz
#   CODE_DIR - Directory of the python code that will be used to get the asset id
function(_tolc_fetch_asset_from_github)
  # Define the supported set of keywords
  set(prefix ARG)
  set(noValues)
  set(singleValues FETCH_VARIABLE USER REPOSITORY TAG ASSET_NAME CODE_DIR)
  set(multiValues)
  # Process the arguments passed in
  cmake_parse_arguments(${prefix} "${noValues}" "${singleValues}"
                        "${multiValues}" ${ARGN})

  find_package(Python3 REQUIRED)
  # Set up virtualenv for the requirements
  set(virtualenv ${CMAKE_CURRENT_BINARY_DIR}/tolc/bootstrap/venv)
  execute_process(
    COMMAND ${Python3_EXECUTABLE} -m venv ${virtualenv}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    RESULT_VARIABLE result)

  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Something went wrong setting up a virtualenv. Exit code: ${result}")
  endif()

  if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL Windows)
    set(virtualenv_python ${virtualenv}/Scripts/python.exe)
  else()
    set(virtualenv_python ${virtualenv}/bin/python)
  endif()

  set(python_pip_args -m pip install -r ${ARG_CODE_DIR}/requirements.txt)
  execute_process(
    COMMAND ${virtualenv_python} ${python_pip_args}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    RESULT_VARIABLE result)

  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Something went wrong downloading dependencies. Exit code: ${result}")
  endif()

  set(python_args
    ${ARG_CODE_DIR}/get_release_id.py
      --user
      ${ARG_USER}
      --repository
      ${ARG_REPOSITORY}
      --tag
      ${ARG_TAG}
      --asset-name
      ${ARG_ASSET_NAME})
  execute_process(
    COMMAND ${virtualenv_python} ${python_args}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    RESULT_VARIABLE result
    OUTPUT_VARIABLE asset_id)

  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Something went wrong trying to find the asset id. Exit code: ${result}. Output: ${asset_id}")
  endif()

  message(
    STATUS "Fetching asset ${ARG_USER}/${ARG_REPOSITORY}/releases/assets/${asset_id}")
  include(FetchContent)
  FetchContent_Declare(
    ${ARG_FETCH_VARIABLE}
    URL https://api.github.com/repos/${ARG_USER}/${ARG_REPOSITORY}/releases/assets/${asset_id}
    HTTP_HEADER "Accept: application/octet-stream")
  FetchContent_Populate(${ARG_FETCH_VARIABLE})

  # Note that things get set on the lowercase version of the input variable
  string(TOLOWER ${ARG_FETCH_VARIABLE} lcName)
  if(NOT ${lcName}_POPULATED)
    FetchContent_Populate(${ARG_FETCH_VARIABLE})
  endif()

  # Export the source directory
  set(${lcName}_SOURCE_DIR
      ${${lcName}_SOURCE_DIR}
      PARENT_SCOPE)
  set(${lcName}_BINARY_DIR
      ${${lcName}_BINARY_DIR}
      PARENT_SCOPE)
endfunction()
