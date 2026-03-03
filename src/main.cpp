#include <fstream>
#include <iostream>

#include "Lexer.hpp"
#include "Parser.hpp"
#include "ExprAstParser.hpp"

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

    ExprParser::Lexer lexer(inputFile);

    Expr* ast = nullptr;
	ExprParser::Parser parser(lexer, ast);

	if (parser.parse() == 0 && ast){
	    std::cout << "Expression: " << ast->toString() << "\n";
		std::cout << "Result: " << ast->evaluate() << "\n";
    } else {
        std::cout << "Parse failed.\n";
	}

	return 0;
}
