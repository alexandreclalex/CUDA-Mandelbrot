cmake_minimum_required(VERSION 3.10)
project(Final CUDA)

set(CMAKE_CUDA_STANDARD 14)

add_executable(Final main.cu colors.cu)

if (${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.18")
    if (NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
        target_compile_options(Final PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-Wno-deprecated-gpu-targets>)
        set_target_properties(Final PROPERTIES CUDA_ARCHITECTURES "50;61;75;")
    endif ()
endif ()
set_target_properties(Final PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
