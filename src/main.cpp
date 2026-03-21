#include <fstream>
#include <iostream>

#include "Lexer.hpp"
#include "Parser.hpp"
#include "codegen.hpp"
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
	    genResult result = ast->genExpr();

		std::ofstream outFile("output.ll");
		outFile << "declare i32 @printf(i8*,...)\n";
		outFile << "define i64 @main() {\n";
		outFile << "entry:\n";

		outFile << result.code;
		outFile << "call i32 (i8*,...) @printf(i8* @.str, i64 " + result.place + ")\n";
		outFile << "ret i64 " << result.place << "\n";
		outFile << "}\n";
		outFile << "@.str = private constant [4 x i8] c\"%d\\0A\\00\"";

		outFile.close();
		std::cout << "LLVM IR code generated\n";
    } else {
        std::cout << "Parse failed.\n";
	}

	return 0;
}
