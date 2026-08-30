cmake_minimum_required(VERSION 3.20)

project(f_tintia_installer LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(f_tintia_installer WIN32
    main.cpp
    installer.rc
    installer.manifest
)

target_compile_definitions(f_tintia_installer PRIVATE
    UNICODE
    _UNICODE
)

target_link_libraries(f_tintia_installer PRIVATE
    shell32
    ole32
    advapi32
)

set_target_properties(f_tintia_installer PROPERTIES
    OUTPUT_NAME "f.Tintia Setup"
)