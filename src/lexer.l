%option lex = "nextToken"
%option lexer = "Lexer"
%option namespace = "AstParser"
%option bison-cc
%option bison-cc-namespace = "AstParser"
%option bison-cc-parser = "Parser"

%{
#include <string>
%}

%top{
#include <string>
#include "Parser.hpp"
}

%%
int                       { return AstParser::Parser::token::KW_INT; }
void                      { return AstParser::Parser::token::KW_VOID; }
if                        { return AstParser::Parser::token::KW_IF; }
else                      { return AstParser::Parser::token::KW_ELSE; }
while                     { return AstParser::Parser::token::KW_WHILE; }
print                     { return AstParser::Parser::token::KW_PRINT; }
def                       { return AstParser::Parser::token::KW_DEF; }
return                    { return AstParser::Parser::token::KW_RETURN; }
ref                       { return AstParser::Parser::token::KW_REF; }

[a-zA-Z_][a-zA-Z0-9_]*    { yylval.emplace<std::string>(text()); return AstParser::Parser::token::IDENTIFIER; }
[0-9]+                    { yylval.emplace<long>(std::stol(text())); return AstParser::Parser::token::NUMBER; }

"+"                       { return AstParser::Parser::token::OP_PLUS; }
"-"                       { return AstParser::Parser::token::OP_MIN; }
"*"                       { return AstParser::Parser::token::OP_MULT; }
"/"                       { return AstParser::Parser::token::OP_DIV; }
"%"                       { return AstParser::Parser::token::OP_MOD; }
"=="                      { return AstParser::Parser::token::OP_EQ; }
"!="                      { return AstParser::Parser::token::OP_NEQ; }
"<"                       { return AstParser::Parser::token::OP_LESS; }
">"                       { return AstParser::Parser::token::OP_GREAT; }
"<="                      { return AstParser::Parser::token::OP_LEQ; }
">="                      { return AstParser::Parser::token::OP_GEQ; }
"&&"                      { return AstParser::Parser::token::OP_AND; }
"||"                      { return AstParser::Parser::token::OP_OR; }
"!"                       { return AstParser::Parser::token::OP_NOT; }
"="                       { return AstParser::Parser::token::OP_ASSIGN; }

";"                       { return AstParser::Parser::token::SEMICOLON; }
","                       { return AstParser::Parser::token::COMA; }
"("                       { return AstParser::Parser::token::LPAREN; }
")"                       { return AstParser::Parser::token::RPAREN; }
"{"                       { return AstParser::Parser::token::LBRACKET; }
"}"                       { return AstParser::Parser::token::RBRACKET; }

\"([^\"\\]\\\")*\"        // { return AstParser::Parser::token::CONST_STR; }
[\t\r\n]+                 // Whitespace, no action
\/\/.*                    // Single Line Comments, no action
<<EOF>>                   { return 0; }
%%
