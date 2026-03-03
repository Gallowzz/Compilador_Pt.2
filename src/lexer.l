%option lex = "nextToken"
%option lexer = "Lexer"
%option namespace = "ExprParser"
%option bison-cc
%option bison-cc-namespace = "ExprParser"
%option bison-cc-parser = "Parser"

%{
#include <string>
%}

%top{
#include <string>
#include "Parser.hpp"
}

%%
[a-zA-Z_][a-zA-Z0-9_]*    { return ExprParser::Parser::token::IDENTIFIER; }
[0-9]+                    { yylval.emplace<int>(std::stoi(text())); return ExprParser::Parser::token::NUMBER; }

"("                       { return ExprParser::Parser::token::OPEN_PAR; }
")"                       { return ExprParser::Parser::token::CLOSE_PAR; }
"+"                       { return ExprParser::Parser::token::OP_PLUS; }
"*"                       { return ExprParser::Parser::token::OP_MULT; }

\"([^\"\\]\\\")*\"        // { return ExprParser::Parser::token::CONST_STR; }
[\t\r\n]+                 // Whitespace, no action
<<EOF>>                   { return 0; }
%%
