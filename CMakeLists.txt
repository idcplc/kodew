cmake_minimum_required(VERSION 3.12)
project (idcplc-bible)

if(APPLE)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Qt5 COMPONENTS Widgets Qml Quick REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(idcplc_SOURCES
    src/main.cpp
    src/highlighter.cpp
    src/dragdrophandler.cpp)

set(idcplc_HEADERS
    src/highlighter.h
    src/dragdrophandler.h)

qt5_add_resources(idcplc_RESOURCES qml.qrc resources.qrc)

add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${idcplc_HEADERS} ${idcplc_SOURCES} ${idcplc_RESOURCES})

target_link_libraries(${PROJECT_NAME} Qt5::Widgets Qt5::Qml Qt5::Quick)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE ${Qt5Widgets_DEFINITIONS} ${QtQml_DEFINITIONS} ${${Qt5Quick_DEFINITIONS}}
)

target_compile_options(${PROJECT_NAME} PRIVATE ${Qt5Widgets_EXECUTABLE_COMPILE_FLAGS} "-Wall" "-Wpedantic")
    
endif()

