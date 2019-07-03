set(extProjectName "zlib")

set(ZLIB_VERSION "1.2.11")
message(STATUS "External Project: ${extProjectName}: ${ZLIB_VERSION}")

set(ZLIB_URL "https://www.zlib.net/fossils/zlib-${ZLIB_VERSION}.tar.gz")

if(WIN32)
  set(ZLIB_INSTALL "${DREAM3D_SDK}/${extProjectName}-${ZLIB_VERSION}")
else()
  set(ZLIB_INSTALL "${DREAM3D_SDK}/${extProjectName}-${ZLIB_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)

if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(C_FLAGS "/DWIN32 /D_WINDOWS /W3 /MP")
  set(C_CXX_FLAGS -DCMAKE_CXX_FLAGS=${CXX_FLAGS} -DCMAKE_C_FLAGS=${C_FLAGS})
endif()

if(LIBARCHIVE_STATIC_ZLIB)
  if(NOT WIN32)
    list(APPEND ZLIB_FLAGS "-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON")
  endif()
endif()

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}-${ZLIB_VERSION}.tar.gz
  URL ${ZLIB_URL}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}"
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${ZLIB_INSTALL}"

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    ${C_CXX_FLAGS}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD=11
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    ${ZLIB_FLAGS}

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure NDE for building
file(APPEND ${DREAM3D_SDK_FILE} "\n")
file(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
file(APPEND ${DREAM3D_SDK_FILE} "# zlib Library Location\n")
if(APPLE)
  file(APPEND ${DREAM3D_SDK_FILE} "set(ZLIB_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${ZLIB_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
elseif(WIN32)
  file(APPEND ${DREAM3D_SDK_FILE} "set(ZLIB_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${ZLIB_VERSION}\" CACHE PATH \"\")\n")
else()
  file(APPEND ${DREAM3D_SDK_FILE} "set(ZLIB_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${ZLIB_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
endif()
file(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${ZLIB_DIR})\n")
