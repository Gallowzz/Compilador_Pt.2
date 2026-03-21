cmake_minimum_required(VERSION 3.15)

project(Compiler)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(GEN_DIR ${CMAKE_BINARY_DIR}/generated)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

file(MAKE_DIRECTORY ${GEN_DIR})

find_package(BISON REQUIRED)
find_package(Reflex REQUIRED)
find_package(TreeCC REQUIRED)

BISON_TARGET(Parser
    ${SRC_DIR}/parser.y
    ${GEN_DIR}/Parser.cpp
    DEFINES_FILE ${GEN_DIR}/Parser.hpp
)

add_custom_command(
    OUTPUT ${GEN_DIR}/Lexer.cpp ${GEN_DIR}/Lexer.hpp
    COMMAND Reflex::Reflex -o ${GEN_DIR}/Lexer.cpp --header-file=${GEN_DIR}/Lexer.hpp ${SRC_DIR}/lexer.l
    DEPENDS ${SRC_DIR}/lexer.l
    COMMENT "Generating lexer with Re/Flex"
)

add_custom_command(
    OUTPUT ${GEN_DIR}/ExprAstParser.cpp ${GEN_DIR}/ExprAstParser.hpp
    COMMAND treecc -o ${GEN_DIR}/ExprAstParser.cpp -h ${GEN_DIR}/ExprAstParser.hpp ${SRC_DIR}/ast.tc
    MAIN_DEPENDENCY ${SRC_DIR}/ast.tc
    COMMENT "Building the AST using TreeCC"
)

add_custom_target(generate_lexer DEPENDS ${GEN_DIR}/Lexer.cpp ${GEN_DIR}/Lexer.hpp)

add_executable(${PROJECT_NAME} ${SRC_DIR}/main.cpp
                               ${GEN_DIR}/Lexer.cpp
                               ${GEN_DIR}/Parser.cpp
                               ${GEN_DIR}/ExprAstParser.cpp
                               ${SRC_DIR}/codegen.cpp
)

target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${SRC_DIR}
        ${GEN_DIR}
)

target_link_libraries(${PROJECT_NAME} PRIVATE Reflex::ReflexLibStatic)
