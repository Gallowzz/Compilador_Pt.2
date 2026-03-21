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
int                       { return ExprParser::Parser::token::KW_INT; }
void                      { return ExprParser::Parser::token::KW_VOID; }
if                        { return ExprParser::Parser::token::KW_IF; }
else                      { return ExprParser::Parser::token::KW_ELSE; }
while                     { return ExprParser::Parser::token::KW_WHILE; }
print                     { return ExprParser::Parser::token::KW_PRINT; }
def                       { return ExprParser::Parser::token::KW_DEF; }
return                    { return ExprParser::Parser::token::KW_RETURN; }
ref                       { return ExprParser::Parser::token::KW_REF; }

[a-zA-Z_][a-zA-Z0-9_]*    { return ExprParser::Parser::token::IDENTIFIER; }
[0-9]+                    { yylval.emplace<int>(std::stoi(text())); return ExprParser::Parser::token::NUMBER; }

"+"                       { return ExprParser::Parser::token::OP_PLUS; }
"-"                       { return ExprParser::Parser::token::OP_MIN; }
"*"                       { return ExprParser::Parser::token::OP_MULT; }
"/"                       { return ExprParser::Parser::token::OP_DIV; }
"%"                       { return ExprParser::Parser::token::OP_MOD; }
"=="                      { return ExprParser::Parser::token::OP_EQ; }
"!="                      { return ExprParser::Parser::token::OP_NEQ; }
"<"                       { return ExprParser::Parser::token::OP_LESS; }
">"                       { return ExprParser::Parser::token::OP_GREAT; }
"<="                      { return ExprParser::Parser::token::OP_LEQ; }
">="                      { return ExprParser::Parser::token::OP_GEQ; }
"&&"                      { return ExprParser::Parser::token::OP_AND; }
"||"                      { return ExprParser::Parser::token::OP_OR; }
"!"                       { return ExprParser::Parser::token::OP_NOT; }
"="                       { return ExprParser::Parser::token::OP_ASSIGN; }

";"                       { return ExprParser::Parser::token::SEMICOLON; }
","                       { return ExprParser::Parser::token::COMA; }
"("                       { return ExprParser::Parser::token::LPAREN; }
")"                       { return ExprParser::Parser::token::RPAREN; }
"{"                       { return ExprParser::Parser::token::LBRACKET; }
"}"                       { return ExprParser::Parser::token::RBRACKET; }

\"([^\"\\]\\\")*\"        // { return ExprParser::Parser::token::CONST_STR; }
[\t\r\n]+                 // Whitespace, no action
\/\/.*                    // Single Line Comments, no action
<<EOF>>                   { return 0; }
%%
