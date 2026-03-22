#include <fstream>
#include <iostream>

#include "Lexer.hpp"
#include "Parser.hpp"
#include "codegen.hpp"
#include "Ast.hpp"

int main(int argc, const char* argv[]) {
	if(argc != 2){
	    std::cerr << "Usage:" << argv[0] << " <input_file>\n";
	    return 1;
	}

	std::ifstream inputFile(argv[1]);
	if(!inputFile.is_open()){
	    std::cerr << "Error opening file: " << argv[1] << "\n";
		return 1;
	}

    AstParser::Lexer lexer(inputFile);

    ProgramNode* ast = nullptr;
    initTable();
	AstParser::Parser parser(lexer, ast);

	if (parser.parse() == 0 && ast){
	    genResult result = ast->genCode();

		std::ofstream outFile("output.ll");
		outFile << "declare i32 @printf(i8*,...)\n";

		outFile << result.code;

		outFile << "@.numStr = private constant [4 x i8] c\"%d\\0A\\00\"";

		outFile.close();
		std::cout << "LLVM IR code generated\n";
    } else {
        std::cout << "Parse failed.\n";
	}

	return 0;
}
