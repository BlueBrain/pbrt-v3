cmake_minimum_required(VERSION 3.8)

# PROJECT DEFINITION
project(pbrt)

# APPEND TO MODULE PATH TO FIND EXTRA CMAKE FILES
list (APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
list (APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}" ${CMAKE_MODULE_PATH})

# FIND REQUIRED PACKAGES
FIND_PACKAGE ( Sanitizers )
FIND_PACKAGE ( Threads )

# TUNE COMPILES BASED ON TYPE
IF(CMAKE_COMPILER_IS_GNUCXX)
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-conversion-null")
ELSEIF(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-register")
ELSEIF(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

  FIND_PROGRAM(XIAR xiar)
  IF(XIAR)
    SET(CMAKE_AR "${XIAR}")
  ENDIF(XIAR)
  MARK_AS_ADVANCED(XIAR)

  FIND_PROGRAM(XILD xild)
  IF(XILD)
    SET(CMAKE_LINKER "${XILD}")
  ENDIF(XILD)
  MARK_AS_ADVANCED(XILD)

  # ICC will default to -fp-model fast=1, which performs value-unsafe optimizations which will
  # cause pbrt_test to fail. For safety, -fp-model precise is explicitly set here by default.
  set(FP_MODEL "precise" CACHE STRING "The floating point model to compile with.")
  set_property(CACHE FP_MODEL PROPERTY STRINGS "precise" "fast=1" "fast=2")

  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fp-model ${FP_MODEL}")
ENDIF()

# PBRT LIBRARY FILES
# HEADERS
list(APPEND PBRT_HEADERS src/pbrt/accelerators/bvh.h)
list(APPEND PBRT_HEADERS src/pbrt/accelerators/kdtreeaccel.h)
list(APPEND PBRT_HEADERS src/pbrt/cameras/environment.h)
list(APPEND PBRT_HEADERS src/pbrt/cameras/orthographic.h)
list(APPEND PBRT_HEADERS src/pbrt/cameras/perspective.h)
list(APPEND PBRT_HEADERS src/pbrt/cameras/realistic.h)
list(APPEND PBRT_HEADERS src/pbrt/core/api.h)
list(APPEND PBRT_HEADERS src/pbrt/core/bssrdf.h)
list(APPEND PBRT_HEADERS src/pbrt/core/camera.h)
list(APPEND PBRT_HEADERS src/pbrt/core/efloat.h)
list(APPEND PBRT_HEADERS src/pbrt/core/error.h)
list(APPEND PBRT_HEADERS src/pbrt/core/fileutil.h)
list(APPEND PBRT_HEADERS src/pbrt/core/film.h)
list(APPEND PBRT_HEADERS src/pbrt/core/filter.h)
list(APPEND PBRT_HEADERS src/pbrt/core/floatfile.h)
list(APPEND PBRT_HEADERS src/pbrt/core/geometry.h)
list(APPEND PBRT_HEADERS src/pbrt/core/integrator.h)
list(APPEND PBRT_HEADERS src/pbrt/core/interaction.h)
list(APPEND PBRT_HEADERS src/pbrt/core/interpolation.h)
list(APPEND PBRT_HEADERS src/pbrt/core/light.h)
list(APPEND PBRT_HEADERS src/pbrt/core/lightdistrib.h)
list(APPEND PBRT_HEADERS src/pbrt/core/lowdiscrepancy.h)
list(APPEND PBRT_HEADERS src/pbrt/core/material.h)
list(APPEND PBRT_HEADERS src/pbrt/core/medium.h)
list(APPEND PBRT_HEADERS src/pbrt/core/memory.h)
list(APPEND PBRT_HEADERS src/pbrt/core/microfacet.h)
list(APPEND PBRT_HEADERS src/pbrt/core/mipmap.h)
list(APPEND PBRT_HEADERS src/pbrt/core/parallel.h)
list(APPEND PBRT_HEADERS src/pbrt/core/paramset.h)
list(APPEND PBRT_HEADERS src/pbrt/core/parser.h)
list(APPEND PBRT_HEADERS src/pbrt/core/pbrt.h)
list(APPEND PBRT_HEADERS src/pbrt/core/primitive.h)
list(APPEND PBRT_HEADERS src/pbrt/core/progressreporter.h)
list(APPEND PBRT_HEADERS src/pbrt/core/quaternion.h)
list(APPEND PBRT_HEADERS src/pbrt/core/reflection.h)
list(APPEND PBRT_HEADERS src/pbrt/core/rng.h)
list(APPEND PBRT_HEADERS src/pbrt/core/sampler.h)
list(APPEND PBRT_HEADERS src/pbrt/core/sampling.h)
list(APPEND PBRT_HEADERS src/pbrt/core/scene.h)
list(APPEND PBRT_HEADERS src/pbrt/core/shape.h)
list(APPEND PBRT_HEADERS src/pbrt/core/sobolmatrices.h)
list(APPEND PBRT_HEADERS src/pbrt/core/spectrum.h)
list(APPEND PBRT_HEADERS src/pbrt/core/stats.h)
list(APPEND PBRT_HEADERS src/pbrt/core/stringprint.h)
list(APPEND PBRT_HEADERS src/pbrt/core/texture.h)
list(APPEND PBRT_HEADERS src/pbrt/core/transform.h)
list(APPEND PBRT_HEADERS src/pbrt/filters/box.h)
list(APPEND PBRT_HEADERS src/pbrt/filters/gaussian.h)
list(APPEND PBRT_HEADERS src/pbrt/filters/mitchell.h)
list(APPEND PBRT_HEADERS src/pbrt/filters/sinc.h)
list(APPEND PBRT_HEADERS src/pbrt/filters/triangle.h)
list(APPEND PBRT_HEADERS src/pbrt/integrators/ao.h)
list(APPEND PBRT_HEADERS src/pbrt/integrators/bdpt.h)
list(APPEND PBRT_HEADERS src/pbrt/integrators/directlighting.h)
list(APPEND PBRT_HEADERS src/pbrt/integrators/mlt.h)
list(APPEND PBRT_HEADERS src/pbrt/integrators/path.h)
list(APPEND PBRT_HEADERS src/pbrt/integrators/sppm.h)
list(APPEND PBRT_HEADERS src/pbrt/integrators/volpath.h)
list(APPEND PBRT_HEADERS src/pbrt/integrators/whitted.h)
list(APPEND PBRT_HEADERS src/pbrt/lights/diffuse.h)
list(APPEND PBRT_HEADERS src/pbrt/lights/distant.h)
list(APPEND PBRT_HEADERS src/pbrt/lights/goniometric.h)
list(APPEND PBRT_HEADERS src/pbrt/lights/infinite.h)
list(APPEND PBRT_HEADERS src/pbrt/lights/point.h)
list(APPEND PBRT_HEADERS src/pbrt/lights/projection.h)
list(APPEND PBRT_HEADERS src/pbrt/lights/spot.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/disney.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/fourier.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/glass.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/hair.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/kdsubsurface.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/matte.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/metal.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/mirror.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/mixmat.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/plastic.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/substrate.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/subsurface.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/translucent.h)
list(APPEND PBRT_HEADERS src/pbrt/materials/uber.h)
list(APPEND PBRT_HEADERS src/pbrt/media/grid.h)
list(APPEND PBRT_HEADERS src/pbrt/media/homogeneous.h)
list(APPEND PBRT_HEADERS src/pbrt/samplers/halton.h)
list(APPEND PBRT_HEADERS src/pbrt/samplers/maxmin.h)
list(APPEND PBRT_HEADERS src/pbrt/samplers/random.h)
list(APPEND PBRT_HEADERS src/pbrt/samplers/sobol.h)
list(APPEND PBRT_HEADERS src/pbrt/samplers/stratified.h)
list(APPEND PBRT_HEADERS src/pbrt/samplers/zerotwosequence.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/cone.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/curve.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/cylinder.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/disk.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/heightfield.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/hyperboloid.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/loopsubdiv.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/nurbs.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/paraboloid.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/sphere.h)
list(APPEND PBRT_HEADERS src/pbrt/shapes/triangle.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/bilerp.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/checkerboard.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/constant.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/dots.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/fbm.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/imagemap.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/marble.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/mix.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/scale.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/uv.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/windy.h)
list(APPEND PBRT_HEADERS src/pbrt/textures/wrinkled.h)

# SOURCES
list(APPEND PBRT_SOURCES src/pbrt/accelerators/bvh.cpp)
list(APPEND PBRT_SOURCES src/pbrt/accelerators/kdtreeaccel.cpp)
list(APPEND PBRT_SOURCES src/pbrt/cameras/environment.cpp)
list(APPEND PBRT_SOURCES src/pbrt/cameras/orthographic.cpp)
list(APPEND PBRT_SOURCES src/pbrt/cameras/perspective.cpp)
list(APPEND PBRT_SOURCES src/pbrt/cameras/realistic.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/api.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/bssrdf.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/camera.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/efloat.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/error.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/fileutil.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/film.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/filter.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/floatfile.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/geometry.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/integrator.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/interaction.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/interpolation.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/light.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/lightdistrib.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/lowdiscrepancy.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/material.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/medium.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/memory.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/microfacet.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/parallel.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/paramset.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/parser.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/primitive.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/progressreporter.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/quaternion.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/reflection.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/sampler.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/sampling.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/scene.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/shape.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/sobolmatrices.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/spectrum.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/stats.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/texture.cpp)
list(APPEND PBRT_SOURCES src/pbrt/core/transform.cpp)
list(APPEND PBRT_SOURCES src/pbrt/filters/box.cpp)
list(APPEND PBRT_SOURCES src/pbrt/filters/gaussian.cpp)
list(APPEND PBRT_SOURCES src/pbrt/filters/mitchell.cpp)
list(APPEND PBRT_SOURCES src/pbrt/filters/sinc.cpp)
list(APPEND PBRT_SOURCES src/pbrt/filters/triangle.cpp)
list(APPEND PBRT_SOURCES src/pbrt/integrators/ao.cpp)
list(APPEND PBRT_SOURCES src/pbrt/integrators/bdpt.cpp)
list(APPEND PBRT_SOURCES src/pbrt/integrators/directlighting.cpp)
list(APPEND PBRT_SOURCES src/pbrt/integrators/mlt.cpp)
list(APPEND PBRT_SOURCES src/pbrt/integrators/path.cpp)
list(APPEND PBRT_SOURCES src/pbrt/integrators/sppm.cpp)
list(APPEND PBRT_SOURCES src/pbrt/integrators/volpath.cpp)
list(APPEND PBRT_SOURCES src/pbrt/integrators/whitted.cpp)
list(APPEND PBRT_SOURCES src/pbrt/lights/diffuse.cpp)
list(APPEND PBRT_SOURCES src/pbrt/lights/distant.cpp)
list(APPEND PBRT_SOURCES src/pbrt/lights/goniometric.cpp)
list(APPEND PBRT_SOURCES src/pbrt/lights/infinite.cpp)
list(APPEND PBRT_SOURCES src/pbrt/lights/point.cpp)
list(APPEND PBRT_SOURCES src/pbrt/lights/projection.cpp)
list(APPEND PBRT_SOURCES src/pbrt/lights/spot.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/disney.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/fourier.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/glass.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/hair.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/kdsubsurface.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/matte.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/metal.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/mirror.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/mixmat.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/plastic.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/substrate.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/subsurface.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/translucent.cpp)
list(APPEND PBRT_SOURCES src/pbrt/materials/uber.cpp)
list(APPEND PBRT_SOURCES src/pbrt/media/grid.cpp)
list(APPEND PBRT_SOURCES src/pbrt/media/homogeneous.cpp)
list(APPEND PBRT_SOURCES src/pbrt/samplers/halton.cpp)
list(APPEND PBRT_SOURCES src/pbrt/samplers/maxmin.cpp)
list(APPEND PBRT_SOURCES src/pbrt/samplers/random.cpp)
list(APPEND PBRT_SOURCES src/pbrt/samplers/sobol.cpp)
list(APPEND PBRT_SOURCES src/pbrt/samplers/stratified.cpp)
list(APPEND PBRT_SOURCES src/pbrt/samplers/zerotwosequence.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/cone.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/curve.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/cylinder.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/disk.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/heightfield.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/hyperboloid.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/loopsubdiv.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/nurbs.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/paraboloid.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/sphere.cpp)
list(APPEND PBRT_SOURCES src/pbrt/shapes/triangle.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/bilerp.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/checkerboard.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/constant.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/dots.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/fbm.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/imagemap.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/marble.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/mix.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/scale.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/uv.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/windy.cpp)
list(APPEND PBRT_SOURCES src/pbrt/textures/wrinkled.cpp)

# DEPENDENCY GLOG
set( WITH_GFLAGS OFF CACHE BOOL "Use gflags" )
set( BUILD_SHARED_LIBS OFF CACHE BOOL " " FORCE )
add_subdirectory( src/ext/glog )
include_directories (
  src/ext/glog/src
  ${PROJECT_BINARY_DIR}/src/ext/glog
)

# CREATE LIBRARY
add_library(pbrt STATIC ${PBRT_HEADERS} ${PBRT_SOURCES})

# SANITETIZE
add_sanitizers ( pbrt )

# ENABLED SPECIFIC C++11 FFEATURES
set ( PBRT_CXX11_FEATURES
  cxx_auto_type
  cxx_explicit_conversions
  cxx_lambdas
  cxx_nullptr
  cxx_range_for
  cxx_static_assert
)
target_compile_features ( pbrt PRIVATE ${PBRT_CXX11_FEATURES} )

# LIBRARY LINK
target_link_libraries(pbrt PUBLIC glog)

# LIBRARY INCLUDES
target_include_directories(
    pbrt PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src/pbrt>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src/pbrt/core>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

# DEVELOPER OPTIONS
option(PBRT_FLOAT_AS_DOUBLE "Use 64-bit floats" OFF)
if (PBRT_FLOAT_AS_DOUBLE)
  target_compile_definitions( pbrt PRIVATE -D PBRT_FLOAT_AS_DOUBLE )
endif()

option(PBRT_SAMPLED_SPECTRUM "Use SampledSpectrum rather than RGBSpectrum" OFF)
if (PBRT_SAMPLED_SPECTRUM)
  target_compile_definitions( pbrt PRIVATE -D PBRT_SAMPLED_SPECTRUM )
endif()

# Required for SDF gemetries lack of precission
option(PBRT_MAX_SSS_HIT_TESTS "Limit number of scene intersection tests for subsurface materials" ON)
if (PBRT_MAX_SSS_HIT_TESTS)
  target_compile_definitions( pbrt PRIVATE -D PBRT_MAX_SSS_HIT_TESTS )
endif()

# HARDCODED DYNAMIC OPTIONS
include(PbrtAddDefinitions)

# INSTALLATION
install(
    TARGETS pbrt
    EXPORT pbrt-config
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
    ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

install(
    EXPORT pbrt-config
    DESTINATION ${CMAKE_INSTALL_PREFIX}/cmake/pbrt)

install(
    DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src/
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include
    FILES_MATCHING PATTERN "*.h")
