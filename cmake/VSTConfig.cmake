# SPDX-License-Identifier: BSD-2-Clause

# This code is part of the sfizz library and is licensed under a BSD 2-clause
# license. You should have receive a LICENSE.md file along with the code.
# If not, contact the sfizz maintainers at https://github.com/sfztools/sfizz

set(VST3_PLUGIN_NAME   "${PROJECT_NAME}")
set(VST3_PLUGIN_VENDOR "${PROJECT_AUTHOR}")
set(VST3_PLUGIN_URL    "${PROJECT_HOMEPAGE_URL}")
set(VST3_PLUGIN_EMAIL  "${PROJECT_EMAIL}")

if(APPLE)
    set(VST3_PLUGIN_INSTALL_DIR "$ENV{HOME}/Library/Audio/Plug-Ins/VST3" CACHE STRING
    "Install destination for VST bundle [default: $ENV{HOME}/Library/Audio/Plug-Ins/VST3]")
    set(AU_PLUGIN_INSTALL_DIR "$ENV{HOME}/Library/Audio/Plug-Ins/Components" CACHE STRING
    "Install destination for AudioUnit bundle [default: $ENV{HOME}/Library/Audio/Plug-Ins/Components]")
elseif(MSVC)
    set(VST3_PLUGIN_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/vst3" CACHE STRING
    "Install destination for VST bundle [default: ${CMAKE_INSTALL_PREFIX}/vst3]")
else()
    set(VST3_PLUGIN_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/lib/vst3" CACHE STRING
    "Install destination for VST bundle [default: ${CMAKE_INSTALL_PREFIX}/lib/vst3]")
endif()

if(NOT VST3_SYSTEM_PROCESSOR)
    set(VST3_SYSTEM_PROCESSOR "${PROJECT_SYSTEM_PROCESSOR}")
endif()

message(STATUS "The system architecture is: ${VST3_SYSTEM_PROCESSOR}")

# --- VST3 Bundle architecture ---
if(NOT VST3_PACKAGE_ARCHITECTURE)
    if(APPLE)
        # VST3 packages are universal on Apple, architecture string not needed
    else()
        if(VST3_SYSTEM_PROCESSOR MATCHES "^(x86_64|amd64|AMD64|x64|X64)$")
            set(VST3_PACKAGE_ARCHITECTURE "x86_64")
        elseif(VST3_SYSTEM_PROCESSOR MATCHES "^(i.86|x86|X86)$")
            if(WIN32)
                set(VST3_PACKAGE_ARCHITECTURE "x86")
            else()
                set(VST3_PACKAGE_ARCHITECTURE "i386")
            endif()
        elseif(VST3_SYSTEM_PROCESSOR MATCHES "^(armv[3-8][a-z]*)$")
            set(VST3_PACKAGE_ARCHITECTURE "${VST3_SYSTEM_PROCESSOR}")
        elseif(VST3_SYSTEM_PROCESSOR MATCHES "^(aarch64)$")
            set(VST3_PACKAGE_ARCHITECTURE "aarch64")
        # We have no much ways to support RISC without machines to test,
        # but at least don't deny the possibility to build
        elseif(VST3_SYSTEM_PROCESSOR MATCHES "^(riscv64)$")
            set(VST3_PACKAGE_ARCHITECTURE "riscv64")
        else()
            message(FATAL_ERROR "We don't know this architecture for VST3: ${VST3_SYSTEM_PROCESSOR}.")
        endif()
    endif()
endif()

message(STATUS "The VST3 architecture is deduced as: ${VST3_PACKAGE_ARCHITECTURE}")
